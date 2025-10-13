# Install and load required packages
install.packages("sf")
library(sf)

# Source the extent and download function
source("R/extent.R")
source("R/downloadFiles.R")

# Create extent variable
extent <- download_and_extract_Kayong()

# File paths
managed_forest_path <- "data/gfw_logging_download_v2020.shp"
wood_fiber_path <- "data/wood_fiber_data.json"

# Crop the managed forest and wood fiber data to the extent of the study area
managed_forest_crop <- createExtent(managed_forest_path, extent)
wood_fiber_crop <- createExtent(wood_fiber_path, extent)

# Combine the two cropped spatial datasets using rbind()
combined_concessions <- rbind(managed_forest_crop, wood_fiber_crop)

# Write the combined GeoJSON to file
st_write(combined_concessions, "data/timber_concessions.geojson", driver = "GeoJSON", delete_dsn = TRUE)