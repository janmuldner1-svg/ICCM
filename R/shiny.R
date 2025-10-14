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
  titlePanel("Land Use Map - North Kayong Regency"),
  
  sidebarLayout(
    sidebarPanel(
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
      
      # Scale bar
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
}

# ===== RUN APP =====
shinyApp(ui = ui, server = server)
