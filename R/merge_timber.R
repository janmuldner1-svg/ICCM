# Install packages
install.packages("jsonlite")
library(jsonlite)

# Source the extent and download function
source("R/extent.R")
source("R/downloadFiles.R")

# Create variables 
extent <- download_and_extract_Kayong()
managed_forest <- "data/gfw_logging_download_v2020.shp"
wood_fiber <- "data/wood_fiber_data.json"


# Crop the managed forest and wood fiber data to the extent of the study area
managed_forest_crop <- createExtent(managed_forest, extent)
wood_fiber_crop <- createExtent(wood_fiber, extent)

# Read the managed forest shapefile 
managed_shape <- st_read("data/gfw_logging_download_v2020.shp")

# Convert managed forest data into a json file
st_write(managed_forest_crop, "data/managed_forest2.json", driver = "GeoJSON")

# Write the wood fiber data into a .json file
st_write(wood_fiber_crop, "data/wood_fiber.json", driver = "GeoJSON")


## Combine managed forest and wood fiber data into one json file (with help of Chatgpt)
# Read the two GeoJSON files
geojson1 <- fromJSON("data/managed_forest2.json")
geojson2 <- fromJSON("data/wood_fiber.json")

# Check that both .json files are feature collections
if (geojson1$type != "FeatureCollection" || geojson2$type != "FeatureCollection") {
  stop("Both files must be GeoJSON FeatureCollections")
}

# Combine the features arrays of the two json files
combined_features <- c(geojson1$features, geojson2$features)

# Create a new FeatureCollection with the features of the two data sets combined
combined_geojson <- list(
  type = "FeatureCollection",
  features = combined_features
)

# Write the combined GeoJSON back to file to create one timber concessions file
write_json(combined_geojson, "dat/timber_concessions.geojson", auto_unbox = TRUE, pretty = TRUE)
