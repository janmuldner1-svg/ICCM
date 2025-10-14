library(shiny)
library(leaflet)
library(sf)

# ===== GLOBAL.R - Load data here =====
concessions <- NULL
palm_concessions <- NULL
kayong_boundary <- NULL
timber_mismatches <- NULL
forest_concessions <- NULL

# Load palm mismatches layer
if (file.exists("output/mismatches_oilpalm.geojson")) {
  concessions <- st_read("output/mismatches_oilpalm.geojson")
  concessions <- st_zm(concessions, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(concessions))) {
    concessions <- st_make_valid(concessions)
  }
  if (!"area_m2" %in% names(concessions)) {
    concessions$area_m2 <- as.numeric(st_area(concessions))
  } else {
    concessions$area_m2 <- as.numeric(concessions$area_m2)
  }
}

# Load palm tree concessions layer
if (file.exists("data/palm_tree_concessions_clipped.geojson")) {
  palm_concessions <- st_read("data/palm_tree_concessions_clipped.geojson")
  palm_concessions <- st_zm(palm_concessions, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(palm_concessions))) {
    palm_concessions <- st_make_valid(palm_concessions)
  }
  palm_concessions$shape_Area <- as.numeric(palm_concessions$shape_Area)
}

# Load forest concessions layer
if (file.exists("data/forest_concessions.geojson")) {
  forest_concessions <- st_read("data/forest_concessions.geojson")
  forest_concessions <- st_zm(forest_concessions, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(forest_concessions))) {
    forest_concessions <- st_make_valid(forest_concessions)
  }
  if (!"area_m2" %in% names(forest_concessions)) {
    forest_concessions$area_m2 <- as.numeric(st_area(forest_concessions))
  } else {
    forest_concessions$area_m2 <- as.numeric(forest_concessions$area_m2)
  }
}

# Load Kayong boundary layer
if (file.exists("data/Kayong_boundary.geojson")) {
  kayong_boundary <- st_read("data/Kayong_boundary.geojson")
  kayong_boundary <- st_zm(kayong_boundary, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(kayong_boundary))) {
    kayong_boundary <- st_make_valid(kayong_boundary)
  }
}

# Load timber mismatches layer
if (file.exists("output/timber_mismatches.geojson")) {
  timber_mismatches <- st_read("output/timber_mismatches.geojson")
  timber_mismatches <- st_zm(timber_mismatches, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(timber_mismatches))) {
    timber_mismatches <- st_make_valid(timber_mismatches)
  }
  if (!"area_m2" %in% names(timber_mismatches)) {
    timber_mismatches$area_m2 <- as.numeric(st_area(timber_mismatches))
  } else {
    timber_mismatches$area_m2 <- as.numeric(timber_mismatches$area_m2)
  }
}

# ===== UI =====
ui <- fluidPage(
  # Add CSS for more visible scale bar
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
  
  titlePanel("Commodity conccession mismatches - North Kayong Regency"),
  
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
                <li><b>Palm Concessions</b>: The 'Oil palm concessions' data set is obtained from Global Forest Watch, last updated in 2023. It refers to areas with current or planned oil palm plantations in Indonesia..</li>
                <li><b>Kayong Boundary</b>: Administrative boundary of the region.</li>
              </ul>
              <p>Use the checkboxes below to toggle layers on the map.</p>")
      ),
      checkboxGroupInput(
        "layer",
        "Layers:",
        choices = c("Palm Mismatches", "Timber Mismatches", "Forest Concessions", "Palm Concessions", "Kayong Boundary"),
        selected = c("Palm Mismatches", "Timber Mismatches", "Forest Concessions", "Palm Concessions", "Kayong Boundary")
      ),
      width = 3
    ),
    
    mainPanel(
      leafletOutput("map", height = "700px"),
      width = 9
    )
  )
)

# ===== SERVER =====
server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery") %>%
      setView(lng = 110.05, lat = -1.07, zoom = 11) %>%
      
      # Custom HTML legend
      addControl(
        html = "<div style='background:white;padding:10px;border-radius:5px;font-size:16px;'>
                  <b>Legend</b><br>
                  <span style='color:red;'>■</span> Palm Mismatches<br>
                  <span style='color:orange;'>■</span> Timber Mismatches<br>
                  <span style='color:blue;'>■</span> Forest Concessions<br>
                  <span style='color:yellow;'>■</span> Palm Concessions<br>
                  <span style='color:purple;'>■</span> Kayong Boundary
                </div>",
        position = "bottomright"
      ) %>%
      
      # Scale bar with default options but now styled via CSS above
      addScaleBar(position = "bottomleft", options = list(imperial = FALSE))
  })
  
  observeEvent(input$layer, {
    leafletProxy("map") %>%
      clearShapes()
    
    # Bottom layer: Kayong Boundary
    if ("Kayong Boundary" %in% input$layer && !is.null(kayong_boundary)) {
      leafletProxy("map") %>%
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
    
    # Next layer: Palm Concessions
    if ("Palm Concessions" %in% input$layer && !is.null(palm_concessions)) {
      leafletProxy("map") %>%
        addPolygons(
          data = palm_concessions,
          fillColor = "yellow",
          fillOpacity = 0.3,
          color = "goldenrod",
          weight = 1,
          popup = ~paste("Company:", company, "<br>Area (km²):", round(shape_Area / 1e6, 2)),
          label = ~paste("Company:", company)
        )
    }
    
    # Next layer: Forest Concessions
    if ("Forest Concessions" %in% input$layer && !is.null(forest_concessions)) {
      leafletProxy("map") %>%
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
    
    # Next layer: Timber Mismatches
    if ("Timber Mismatches" %in% input$layer && !is.null(timber_mismatches)) {
      leafletProxy("map") %>%
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
    
    # Top layer: Palm Mismatches
    if ("Palm Mismatches" %in% input$layer && !is.null(concessions)) {
      leafletProxy("map") %>%
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
  })
  
  # ===== TABLE OUTPUT =====
  output$layer_table <- renderTable({
    layers <- list()
    
    if ("Palm Mismatches" %in% input$layer && !is.null(concessions)) {
      layers[["Palm Mismatches"]] <- data.frame(
        Features = nrow(concessions),
        Area_km2 = round(sum(concessions$area_m2, na.rm = TRUE) / 1e6, 2)
      )
    }
    
    if ("Timber Mismatches" %in% input$layer && !is.null(timber_mismatches)) {
      layers[["Timber Mismatches"]] <- data.frame(
        Features = nrow(timber_mismatches),
        Area_km2 = round(sum(timber_mismatches$area_m2, na.rm = TRUE) / 1e6, 2)
      )
    }
    
    if ("Forest Concessions" %in% input$layer && !is.null(forest_concessions)) {
      layers[["Forest Concessions"]] <- data.frame(
        Features = nrow(forest_concessions),
        Area_km2 = round(sum(forest_concessions$area_m2, na.rm = TRUE) / 1e6, 2)
      )
    }
    
    if ("Palm Concessions" %in% input$layer && !is.null(palm_concessions)) {
      layers[["Palm Concessions"]] <- data.frame(
        Features = nrow(palm_concessions),
        Area_km2 = round(sum(palm_concessions$shape_Area, na.rm = TRUE) / 1e6, 2)
      )
    }
    
    if ("Kayong Boundary" %in% input$layer && !is.null(kayong_boundary)) {
      layers[["Kayong Boundary"]] <- data.frame(
        Features = nrow(kayong_boundary),
        Area_km2 = NA
      )
    }
    
    do.call(rbind, layers)
  }, rownames = TRUE)
}
