library(shiny)
library(leaflet)
library(sf)
library(base64enc)  # for encoding images as base64

# ===== SERVER =====
server <- function(input, output, session) {
  
  # Convert the north arrow PNG image to a base64 data URI once when the server starts.
  # Embedding this image in the leaflet map avoids issues with file serving.
  img_base64 <- base64enc::dataURI(file = "www/north_arrow.png", mime = "image/png")
  
  # Render the initial Leaflet map with base imagery and UI controls
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery") %>%   # Satellite imagery base layer
      setView(lng = 110.05, lat = -1.07, zoom = 11) %>%  # Center on North Kayong Regency
      
      # Add the north arrow image as a fixed control in the top-right corner of the map
      addControl(
        html = sprintf("<img src='%s' style='width:70px; opacity:0.8;'>", img_base64),
        position = "topright"
      ) %>%
      
      # Add a custom legend describing the meaning of each color on the map
      addControl(
        html = "<div style='background:white; padding:12px 15px; border-radius:5px; font-size:16px; font-weight:bold; box-shadow: 0 0 8px rgba(0,0,0,0.3);'>
                  <b>Legend</b><br>
                  <span style='color:red;'>■</span> Palm Mismatches<br>
                  <span style='color:orange;'>■</span> Timber Mismatches<br>
                  <span style='color:blue;'>■</span> Forest Concessions<br>
                  <span style='color:yellow;'>■</span> Palm Concessions<br>
                  <span style='color:purple;'>■</span> Kayong Boundary
                </div>",
        position = "bottomright"
      ) %>%
      
      # Add a scale bar (metric units only), styled by your CSS
      addScaleBar(position = "bottomleft", options = list(imperial = FALSE))
  })
  
  # Observe layer selection input and update the displayed layers on the map accordingly
  observeEvent(input$layer, {
    leafletProxy("map") %>%
      clearShapes()  # Clear all polygons before adding new ones
    
    # Add the Kayong Boundary polygon if selected
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
    
    # Add Palm Concessions polygons if selected
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
    
    # Add Forest Concessions polygons if selected
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
    
    # Add Timber Mismatches polygons if selected
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
    
    # Add Palm Mismatches polygons if selected
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
  
  # Render a summary table showing counts and areas of selected layers
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
        Area_km2 = NA  # No area calculation for boundary polygons here
      )
    }
    
    # Combine all data frames into one for display
    do.call(rbind, layers)
  }, rownames = TRUE)
}

# ===== UI =====
ui <- fluidPage(
  # Custom CSS to style the scale bar for better visibility
  tags$head(
    tags$style(HTML("
  .leaflet-control-scale {
    background-color: white !important;
    padding: 8px 12px;
    border-radius: 5px;
    font-size: 18px;       /* bigger font size */
    font-weight: bold;
    box-shadow: 0 0 8px rgba(0,0,0,0.3)
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