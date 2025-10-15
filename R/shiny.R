library(shiny)
library(leaflet)
library(sf)
library(base64enc)  # For base64 image encoding

# ==== Load your spatial data ====

concessions <- NULL
palm_concessions <- NULL
kayong_boundary <- NULL
timber_mismatches <- NULL
forest_concessions <- NULL
biggest_oilpalm <- NULL
biggest_timber <- NULL

if (file.exists("output/mismatches_oilpalm.geojson")) {
  concessions <- st_read("output/mismatches_oilpalm.geojson")
  concessions <- st_zm(concessions, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(concessions))) concessions <- st_make_valid(concessions)
  concessions$area_m2 <- as.numeric(concessions$area_m2 %||% st_area(concessions))
}

if (file.exists("data/palm_tree_concessions_clipped.geojson")) {
  palm_concessions <- st_read("data/palm_tree_concessions_clipped.geojson")
  palm_concessions <- st_zm(palm_concessions, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(palm_concessions))) palm_concessions <- st_make_valid(palm_concessions)
  palm_concessions$shape_Area <- as.numeric(palm_concessions$shape_Area)
}

if (file.exists("data/forest_concessions.geojson")) {
  forest_concessions <- st_read("data/forest_concessions.geojson")
  forest_concessions <- st_zm(forest_concessions, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(forest_concessions))) forest_concessions <- st_make_valid(forest_concessions)
  forest_concessions$area_m2 <- as.numeric(forest_concessions$area_m2 %||% st_area(forest_concessions))
}

if (file.exists("data/Kayong_boundary.geojson")) {
  kayong_boundary <- st_read("data/Kayong_boundary.geojson")
  kayong_boundary <- st_zm(kayong_boundary, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(kayong_boundary))) kayong_boundary <- st_make_valid(kayong_boundary)
}

if (file.exists("output/timber_mismatches.geojson")) {
  timber_mismatches <- st_read("output/timber_mismatches.geojson")
  timber_mismatches <- st_zm(timber_mismatches, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(timber_mismatches))) timber_mismatches <- st_make_valid(timber_mismatches)
  timber_mismatches$area_m2 <- as.numeric(timber_mismatches$area_m2 %||% st_area(timber_mismatches))
}

if (file.exists("output/biggest_mismatches_oilpalm.geojson")) {
  biggest_oilpalm <- st_read("output/biggest_mismatches_oilpalm.geojson")
  biggest_oilpalm <- st_zm(biggest_oilpalm, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(biggest_oilpalm))) biggest_oilpalm <- st_make_valid(biggest_oilpalm)
  biggest_oilpalm$area_m2 <- as.numeric(biggest_oilpalm$area_m2 %||% st_area(biggest_oilpalm))
}

if (file.exists("output/biggest_timber_mismatches.geojson")) {
  biggest_timber <- st_read("output/biggest_timber_mismatches.geojson")
  biggest_timber <- st_zm(biggest_timber, drop = TRUE, what = "ZM")
  if (!all(st_is_valid(biggest_timber))) biggest_timber <- st_make_valid(biggest_timber)
  biggest_timber$area_m2 <- as.numeric(biggest_timber$area_m2 %||% st_area(biggest_timber))
}

# === Base64 encode the north arrow image once globally ===
img_base64 <- base64enc::dataURI(file = "www/north_arrow.png", mime = "image/png")

# ==== UI ====
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
                <li><b>Forest Concessions</b>: Managed forest areas for timber and wood fiber production.</li>
                <li><b>Palm Concessions</b>: Areas with current or planned oil palm plantations.</li>
                <li><b>Kayong Boundary</b>: Administrative boundary of the region.</li>
                <li><b>Biggest Palm Mismatches</b>: 10 Largest palm mismatches in opaque red.</li>
                <li><b>Biggest Timber Mismatches</b>: 10 Largest timber mismatches in opaque yellow.</li>
              </ul>
              <p>Use the checkboxes below to toggle layers on the map.</p>")
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
      width = 9
    )
  )
)

# ==== SERVER ====
server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery") %>%
      setView(lng = 110.05, lat = -1.07, zoom = 11) %>%
      
      # Add scale bar (metric only) in bottom left
      addScaleBar(position = "bottomleft", options = list(imperial = FALSE)) %>%
      
      # Add the north arrow image control (top right)
      addControl(
        html = sprintf("<img src='%s' style='width:60px; opacity:0.8;'>", img_base64),
        position = "topright"
      ) %>%
      
      # Add static legend box bottom right
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
    leafletProxy("map") %>%
      clearShapes()
    
    # Kayong Boundary (bottom layer)
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
    
    # Palm Concessions
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
    
    # Forest Concessions
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
    
    # Timber Mismatches, with popup showing deforestation year from 'layer' column
    if ("Timber Mismatches" %in% input$layer && !is.null(timber_mismatches)) {
      leafletProxy("map") %>%
        addPolygons(
          data = timber_mismatches,
          fillColor = "orange",
          fillOpacity = 0.4,
          color = "darkorange",
          weight = 1,
          popup = ~paste0("Area (km²): ", round(area_m2 / 1e6, 2),
                          "<br>Deforestation Year: ", 2000 + as.numeric(layer)),
          label = ~paste0("Year: ", 2000 + as.numeric(layer))
        )
    }
    
    # Palm Mismatches (top layer)
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
    
    # Biggest Palm Mismatches (same fill as Palm Mismatches but black border)
    if ("Biggest Palm Mismatches" %in% input$layer && !is.null(biggest_oilpalm)) {
      leafletProxy("map") %>%
        addPolygons(
          data = biggest_oilpalm,
          fillColor = "red",
          fillOpacity = 1,
          color = "black",       # black border
          weight = 2,
          popup = ~paste("Area (km²):", round(area_m2 / 1e6, 2)),
          label = ~paste("Area (km²):", round(area_m2 / 1e6, 2))
        )
    }
    
    # Biggest Timber Mismatches (same fill as Timber Mismatches but black border)
    if ("Biggest Timber Mismatches" %in% input$layer && !is.null(biggest_timber)) {
      leafletProxy("map") %>%
        addPolygons(
          data = biggest_timber,
          fillColor = "orange",
          fillOpacity = 1,
          color = "black",       # black border
          weight = 2,
          popup = ~paste0("Area (km²): ", round(area_m2 / 1e6, 2),
                          "<br>Deforestation Year: ", 2000 + as.numeric(layer)),
          label = ~paste0("Year: ", 2000 + as.numeric(layer))
        )
    }
  })
}