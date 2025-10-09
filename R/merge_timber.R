# Install packages
install.packages("jsonlite")
library(jsonlite)

# Source the extent and download function
source("R/extent.R")
source("R/downloadFiles.R")

# Create variables 
extent <- download_and_extract_Kayong()
managed_forest <- "data/gfw_logging_download_v2020.shp"


# Crop the managed forest data to the extent of the study area
managed_forest_crop <- createExtent(managed_forest, extent)

# Read the managed forest shapefile 
managed_shape <- st_read("data/gfw_logging_download_v2020.shp")

# Convert managed forest data into a json file
st_write(managed_shape, "data/managed_forest.json", driver = "GeoJSON")

# Combine managed forest and wood fiber data into one json file 
