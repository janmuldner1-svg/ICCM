# Please follow the instructions in the README.md before running this script:)

# Create necessary directories
if(!dir.exists("tempfiles")){dir.create("tempfiles")}
if(!dir.exists("data")){dir.create("data")}
if(!dir.exists("output")){dir.create("output")}

# import packages
library(sf)
library(sits)
library(terra)

# Source the download function
source("R/downloadFiles.R")
source("R/extent.R")
source("R/identifyMismatches.R")
source("R/merge_timber.R")
source("R/concessions_combined.R")
source("R/shiny.R")

# Make sure the .zip file added from MS Teams gets unzipped
unzip("data/managed_forest_data.zip", exdir = "data")

# Download the official extent of the Kayong Regency (ROI)
download_and_extract_Kayong("https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/IDN/ADM2/geoBoundaries-IDN-ADM2_simplified.geojson")
extent <- "data/Kayong_boundary.geojson"

# Download the official timber and oil palm concession data
download_wood_fiber_concessions("http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json")
wood_fiber_data = "data/wood_fiber_data.json"
managed_forest_path <- "data/gfw_logging_download_v2020.shp"

download_oil_palm_concessions("https://hub.arcgis.com/api/v3/datasets/f82b539b9b2f495e853670ddc3f0ce68_2/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1")
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

# Combine oil and wood concession data
combined_concessions <- concessions_combined(oil_palm_concessions_clipped, combined_forest_concessions)

### OIL PALM MISMATCHES ###
mismatches_oil_palm <- Identify_mismatch_polygons(oil_palm_plantations_clipped, oil_palm_concessions_clipped)
stats_oil_palm <- Statistics(mismatches_oil_palm)

### TIMBER MISMATCHES ###
mismatches_wood <- Identify_mismatch_polygons(forest_loss_clipped, combined_forest_concessions)
stats_wood <- Statistics(mismatches_wood)

### STORE RESULTS ###

## Store the statistical results as .csv files ##

#  Stats for oil palms
write.csv(stats_oil_palm, file = "output/stats_oil_palm.csv", row.names = FALSE)

# Stats for timber
write.csv(stats_wood, file = "output/stats_timber.csv", row.names = FALSE)

print("The results were saved into /output directory as .csv file")

## Store the mismatches as .json files into output ##


###

#potentially use/remove
# Write GeoJSON of filtered polygons
st_write(filtered_polygons_sf, "output/filtered_polygons_oilpalm.geojson")

# ===== RUN SHINY APP =====
shinyApp(ui = ui, server = server)
