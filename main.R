# Please follow the instructions in the README.md before running this script:)

# Create necessary directories
if(!dir.exists("tempfiles")){dir.create("tempfiles")}
if(!dir.exists("data")){dir.create("data")}
if(!dir.exists("output")){dir.create("output")}

# import packages
library(sf)
library(terra)
library(dplyr)

# Sources to load functions
source("R/downloadFiles.R")
source("R/extent.R")
source("R/identifyMismatches.R")
source("R/merge_timber.R")
source("R/concessions_combined.R")
source("R/GetLargestMismatches.R")
source("R/saveOutput.R")
source("R/statistics.R")

# Make sure the .zip file added from MS Teams gets unzipped
unzip("data/managed_forest_data.zip", exdir = "data")

# Download the official extent of the Kayong Regency (ROI)
download_and_extract_Kayong("https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/IDN/ADM2/geoBoundaries-IDN-ADM2_simplified.geojson")
extent <- st_read("data/Kayong_boundary.geojson")

# Download the official timber and oil palm concession data
download_wood_fiber_concessions("http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json")
wood_fiber_data = st_read("data/wood_fiber_data.json")
managed_forest_path <- st_read("data/gfw_logging_download_v2020.shp")

download_oil_palm_concessions("https://hub.arcgis.com/api/v3/datasets/f82b539b9b2f495e853670ddc3f0ce68_2/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1")
oil_palm_concessions <- st_read("data/palm_tree_concessions.json")

# Download open source data for oil palm plantations and forest loss
oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")
forest_loss <- rast("data/west_kalimantan_forest_loss_year.tif")
# Select year 2019-2025 for forest loss
forest_loss_2019_2024 <- ifel(forest_loss >= 19 & forest_loss <= 24, forest_loss, NA)

# Limit areas of datasets to the extent
oil_palm_concessions_clipped <- createExtent(oil_palm_concessions, extent)
oil_palm_plantations_clipped <- createExtent(oil_palm_plantations, extent)

wood_fiber_clipped <- createExtent(wood_fiber_data, extent)
managed_forest_clipped <- createExtent(managed_forest_path, extent)
forest_loss_clipped <- createExtent(forest_loss_2019_2024, extent)

# Combine all wood concession data
combined_forest_concessions <-merge_timber(managed_forest_clipped, wood_fiber_clipped)

# Combine oil palm and wood concession data
combined_concessions <- concessions_combined(oil_palm_concessions_clipped, combined_forest_concessions)

### OIL PALM MISMATCHES ###
mismatches_oil_palm <- Identify_mismatch_polygons(oil_palm_plantations_clipped, oil_palm_concessions_clipped)
stats_oil_palm <- Statistics(mismatches_oil_palm)

### TIMBER MISMATCHES ###
mismatches_wood <- Identify_mismatch_polygons(forest_loss_clipped, combined_concessions)
stats_wood <- Statistics(mismatches_wood)

### FIND BIGGEST MISMATCHES ###
biggest_palm_mismatches <- get_largest_mismatches(mismatches_oil_palm)
biggest_timber_mismatches <-get_largest_mismatches(mismatches_wood)

### STORE RESULTS ###

## Store the statistical results as .csv files ##

#  Stats for oil palms
save_output(stats_oil_palm, "stats_oil_palm.csv")
write.csv(stats_oil_palm, file = "output/stats_oil_palm.csv", row.names = FALSE)

# Stats for timber
save_output(stats_wood, "stats_timber.csv")
write.csv(stats_wood, file = "output/stats_timber.csv", row.names = FALSE)

print("The results were saved into /output directory as .csv file")

## Store the mismatches as .geojson files into output ##
save_output(mismatches_oil_palm, "mismatches_oilpalm.geojson")
save_output(oil_palm_concessions_clipped, "palm_tree_concessions_clipped.geojson", output_dir = "data")
save_output(combined_forest_concessions, "forest_concessions.geojson", output_dir = "data")
save_output(mismatches_oil_palm, "mismatches_oilpalm.geojson")
save_output(mismatches_wood, "timber_mismatches.geojson")
save_output(biggest_palm_mismatches, "biggest_mismatches_oilpalm.geojson")
save_output(biggest_timber_mismatches, "biggest_timber_mismatches.geojson")

# ===== RUN SHINY APP =====
# For visualization
source("R/shiny.R")

shinyApp(ui = ui, server = server)
