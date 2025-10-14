# import packages
library(sf)
library(sits)
library(terra)

# Create necessary directories
if(!dir.exists("tempfiles")){dir.create("tempfiles")}
if(!dir.exists("data")){dir.create("data")}
if(!dir.exists("output")){dir.create("output")}

# Source the download function
source("R/downloadFiles.R")
source("R/extent.R")
source("R/identifyMismatches.R")
source("R/merge_timber.R")

# Download the official extent of the Kayong Regency (ROI)
download_and_extract_Kayong()
extent <- "data/Kayong_boundary.geojson"

# Download the official timber and oil palm concession data
download_wood_fiber_concessions()
wood_fiber_data = "data/wood_fiber_data.json"
managed_forest_path <- "data/gfw_logging_download_v2020.shp"

download_oil_palm_concessions()
oil_palm_concessions <- "data/palm_tree_concessions.json"

# Download open source data for oil palm plantations and forest loss
oil_palm_plantations <- "data/ketapang_palm_2023_90.tif"
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

### OIL PALM MISMATCHES ###
mismatches_oil_palm <- Identify_mismatch_polygons(oil_palm_plantations_clipped, oil_palm_concessions_clipped)
stats_oil_palm <- Statistics(mismatches_oil_palm)

### TIMBER MISMATCHES ###
mismatches_wood <- Identify_mismatch_polygons(forest_loss_clipped, combined_forest_concessions)
stats_wood <- Statistics(mismatches_wood)

###
###

#potentially use/remove
# Write GeoJSON of filtered polygons
st_write(filtered_polygons_sf, "output/filtered_polygons_oilpalm.geojson")


