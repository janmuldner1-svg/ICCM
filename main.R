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

# Download the official extent of the Kayong Regency (ROI)
download_and_extract_Kayong()
extent <- "data/Kayong_boundary.geojson"

# Download the official timber and oil palm concession data
download_wood_fiber_concessions()
wood_fiber_data = "data/wood_fiber_data.json"

download_oil_palm_concessions()
oil_palm_concessions <- "data/palm_tree_concessions.json"

# Download the oil palm plantations
oil_palm_plantations <- "data/ketapang_palm_2023_90.tif"

# Limit areas of datasets to the extent
wood_fiber_clipped <- createExtent(wood_fiber_data, extent)
oil_palm_concessions_clipped <- createExtent(oil_palm_concessions, extent)
oil_palm_plantations_clipped <- createExtent(oil_palm_plantations, extent)

plot(oil_palm_plantations_clipped)

### OIL PALM ###
mismatches_oil_palm <- Identify_mismatch_polygons(oil_palm_plantations_clipped, oil_palm_concessions_clipped)
stats_oil_palm <- Statistics(mismatches_oil_palm)

### TIMBER ###




###
###

#potentially use/remove
# Write GeoJSON of filtered polygons
st_write(filtered_polygons_sf, "output/filtered_polygons_oilpalm.geojson")


