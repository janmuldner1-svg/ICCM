library(shiny)
library(leaflet)
library(sf)
library(DT)
library(base64enc)

# ==== Load spatial data ====
concessions <- if (file.exists("output/mismatches_oilpalm.geojson")) {
  st_read("output/mismatches_oilpalm.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . } %>%
    { .$area_m2 <- as.numeric(.$area_m2 %||% st_area(.)); . }
} else NULL

palm_concessions <- if (file.exists("data/palm_tree_concessions_clipped.geojson")) {
  st_read("data/palm_tree_concessions_clipped.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . } %>%
    { .$area_m2 <- as.numeric(.$shape_Area %||% st_area(.)); . }
} else NULL

forest_concessions <- if (file.exists("data/forest_concessions.geojson")) {
  st_read("data/forest_concessions.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . } %>%
    { .$area_m2 <- as.numeric(.$area_m2 %||% st_area(.)); . }
} else NULL

kayong_boundary <- if (file.exists("data/Kayong_boundary.geojson")) {
  st_read("data/Kayong_boundary.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . }
} else NULL

timber_mismatches <- if (file.exists("output/timber_mismatches.geojson")) {
  st_read("output/timber_mismatches.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . } %>%
    { .$area_m2 <- as.numeric(.$area_m2 %||% st_area(.)); . }
} else NULL

biggest_oilpalm <- if (file.exists("output/biggest_mismatches_oilpalm.geojson")) {
  st_read("output/biggest_mismatches_oilpalm.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . } %>%
    { .$area_m2 <- as.numeric(.$area_m2 %||% st_area(.)); . }
} else NULL

biggest_timber <- if (file.exists("output/biggest_timber_mismatches.geojson")) {
  st_read("output/biggest_timber_mismatches.geojson") %>%
    st_zm(drop = TRUE) %>%
    { if (!all(st_is_valid(.))) st_make_valid(.) else . } %>%
    { .$area_m2 <- as.numeric(.$area_m2 %||% st_area(.)); . }
} else NULL

img_base64 <- base64enc::dataURI(file = "www/north_arrow.png", mime = "image/png")

ensure_area_m2 <- function(sf_obj) {
  if (is.null(sf_obj$area_m2)) {
    sf_obj$area_m2 <- as.numeric(st_area(sf_obj))
  }
  sf_obj
}

Statistics <- function(mismatch_sf, reference_sf = NULL) {
  mismatch_sf <- ensure_area_m2(mismatch_sf)
  if (!is.null(reference_sf)) {
    reference_sf <- ensure_area_m2(reference_sf)
  }
  
  n_polygons <- nrow(mismatch_sf)
  total_area <- sum(mismatch_sf$area_m2, na.rm = TRUE)
  mean_area <- mean(mismatch_sf$area_m2, na.rm = TRUE)
  sd_area <- sd(mismatch_sf$area_m2, na.rm = TRUE)
  n_football_fields <- total_area / 7140
  
  pct_mismatch <- NA
  if (!is.null(reference_sf)) {
    total_ref_area <- sum(reference_sf$area_m2, na.rm = TRUE)
    if (total_ref_area > 0) {
      pct_mismatch <- (total_area / total_ref_area) * 100
    }
  }
  
  # Round all numeric values to 2 decimals
  data.frame(
    "Number of Mismatches" = n_polygons,
    "Total Mismatch Area (km²)" = round(total_area / 1e6, 2),
    "Mean Mismatch Area (km²)" = round(mean_area / 1e6, 2),
    "SD Mismatch Area (km²)" = round(sd_area / 1e6, 2),
    "Football Field Equivalent" = round(n_football_fields, 2),
    "Mismatch Area as part of Total Area in Percentage (%)" = round(pct_mismatch, 2)
  )
}

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .leaflet-control-scale {
        background-color: white !important;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 16px;
        font-weight: bold;
        box-shadow: 0 0 8px rgba(0,0,0,0.2);
      }
    "))
  ),
  
  titlePanel("Commodity concession mismatches - North Kayong Regency"),
  
  sidebarLayout(
    sidebarPanel(
      tags$div(
        style = "margin-bottom:20px;",
        HTML("<h4>About this map</h4>
              <p>This interactive map displays concession mismatches for oil palm and timber commodities for the North Kayong Regency in West Kalimantan, Indonesia. You can toggle layers to explore:</p>
              <ul>
                <li><b>Palm Mismatches</b>: Areas where oil palms are cultivated outside of designated concession zones.</li>
                <li><b>Timber Mismatches</b>: Areas with noticeable forest loss outside of managed/ wood fiber concessions.</li>
                <li><b>Forest Concessions</b>: The 'Timber concessions' data set is a merged dataset of the Managed Forests (MF) and Wood Fiber (WF) concessions obtained from Global Forest Watch, last updated in 2023 and 2019 respectively. It refers to areas allocated by a government for harvesting timber and other wood products in a public forest, as well as areas issued locally for the exclusive production of pulp and paper products.</li>
                <li><b>Palm Concessions</b>: The 'Oil palm concessions' data set is obtained from Global Forest Watch, last updated in 2023. It refers to areas with current or planned oil palm plantations in Indonesia.</li>
                <li><b>Kayong Boundary</b>: Administrative boundary of the region.</li>
                <li><b>Biggest Palm Mismatches</b>: Top 10 largest palm mismatches (opaque red).</li>
                <li><b>Biggest Timber Mismatches</b>: Top 10 largest timber mismatches (opaque yellow).</li>
              </ul>
              <p>Use the checkboxes below to toggle layers on the map. Click on a region for more information.</p>")
      ),
      checkboxGroupInput(
        "layer",
        "Layers:",
        choices = c(
          "Palm Mismatches", "Timber Mismatches", "Forest Concessions",
          "Palm Concessions", "Kayong Boundary",
          "Biggest Palm Mismatches", "Biggest Timber Mismatches"
        ),
        selected = c("Palm Mismatches", "Timber Mismatches", "Forest Concessions", "Palm Concessions", "Kayong Boundary")
      ),
      width = 3
    ),
    
    mainPanel(
      leafletOutput("map", height = "700px"),
      
      conditionalPanel(
        condition = "input.layer.includes('Palm Mismatches')",
        h3("Statistics - Palm Mismatches"),
        DTOutput("table_oil_palm"),
        br()
      ),
      
      conditionalPanel(
        condition = "input.layer.includes('Timber Mismatches')",
        h3("Statistics - Timber Mismatches"),
        DTOutput("table_wood")
      ),
      
      width = 9
    )
  )
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery") %>%
      setView(lng = 110.05, lat = -1.07, zoom = 11) %>%
      addScaleBar(position = "bottomleft", options = list(imperial = FALSE)) %>%
      addControl(
        html = sprintf("<img src='%s' style='width:60px; opacity:0.8;'>", img_base64),
        position = "topright"
      ) %>%
      addControl(
        html = "<div style='background:white;padding:10px;border-radius:5px;font-size:16px;box-shadow:0 0 8px rgba(0,0,0,0.2);'>
                  <b>Legend</b><br>
                  <span style='color:red;'>■</span> Palm Mismatches<br>
                  <span style='color:orange;'>■</span> Timber Mismatches<br>
                  <span style='color:blue;'>■</span> Forest Concessions<br>
                  <span style='color:yellow;'>■</span> Palm Concessions<br>
                  <span style='color:purple;'>■</span> Kayong Boundary<br>
                  <span style='color:red;'>■</span> Biggest Palm Mismatches<br>
                  <span style='color:orange;'>■</span> Biggest Timber Mismatches
                </div>",
        position = "bottomright"
      )
  })
  
  observeEvent(input$layer, {
    proxy <- leafletProxy("map") %>% clearShapes()
    
    if ("Kayong Boundary" %in% input$layer && !is.null(kayong_boundary)) {
      proxy %>%
        addPolygons(
          data = kayong_boundary,
          fillColor = "transparent",
          fillOpacity = 0,
          color = "purple",
          weight = 3,
          opacity = 1,
          popup = ~paste("Region:", shapeName),
          label = ~paste("Region:", shapeName)
        )
    }
    
    if ("Palm Concessions" %in% input$layer && !is.null(palm_concessions)) {
      proxy %>%
        addPolygons(
          data = palm_concessions,
          fillColor = "yellow",
          fillOpacity = 0.3,
          color = "goldenrod",
          weight = 1,
          popup = ~paste("Company:", company, "<br>Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Company:", company)
        )
    }
    
    if ("Forest Concessions" %in% input$layer && !is.null(forest_concessions)) {
      proxy %>%
        addPolygons(
          data = forest_concessions,
          fillColor = "blue",
          fillOpacity = 0.3,
          color = "darkblue",
          weight = 1,
          popup = ~paste("Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Area (km²):", round(area_m2 / 1e6, 2))
        )
    }
    
    if ("Timber Mismatches" %in% input$layer && !is.null(timber_mismatches)) {
      proxy %>%
        addPolygons(
          data = timber_mismatches,
          fillColor = "orange",
          fillOpacity = 0.4,
          color = "darkorange",
          weight = 1,
          popup = ~paste("Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Area (km²):", round(area_m2 / 1e6, 2))
        )
    }
    
    if ("Palm Mismatches" %in% input$layer && !is.null(concessions)) {
      proxy %>%
        addPolygons(
          data = concessions,
          fillColor = "red",
          fillOpacity = 0.4,
          color = "darkred",
          weight = 1,
          popup = ~paste("Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Area (km²):", round(area_m2 / 1e6, 2))
        )
    }
    
    if ("Biggest Palm Mismatches" %in% input$layer && !is.null(biggest_oilpalm)) {
      proxy %>%
        addPolygons(
          data = biggest_oilpalm,
          fillColor = "red",
          fillOpacity = 1,
          color = "black",
          weight = 2,
          popup = ~paste("Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Area (km²):", round(area_m2 / 1e6, 2))
        )
    }
    
    if ("Biggest Timber Mismatches" %in% input$layer && !is.null(biggest_timber)) {
      proxy %>%
        addPolygons(
          data = biggest_timber,
          fillColor = "orange",
          fillOpacity = 1,
          color = "black",
          weight = 2,
          popup = ~paste("Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Area (km²):", round(area_m2 / 1e6, 2))
        )
    }
  })
  
  output$table_oil_palm <- renderDT({
    req(concessions, palm_concessions)
    stats_oil_palm <- Statistics(concessions, palm_concessions)
    datatable(stats_oil_palm, options = list(dom = 't', paging = FALSE), rownames = FALSE)
  })
  
  output$table_wood <- renderDT({
    req(timber_mismatches, forest_concessions)
    stats_wood <- Statistics(timber_mismatches, forest_concessions)
    datatable(stats_wood, options = list(dom = 't', paging = FALSE), rownames = FALSE)
  })
  
}
