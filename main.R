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
source("R/Oil_Palm_Clipping.R")

# Download the official extent of Kayong Regency (ROI)
download_and_extract_Kayong()
extent <- "data/Kayong_boundary.geojson"

# Download the official timber and oil palm concession data 
download_wood_fiber_concessions()
wood_fiber_data = "data/wood_fiber_data.json"

download_oil_palm_concessions()
oil_palm_concessions <- "data/palm_tree_concessions.json"
oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")

# Limit areas of dataset to the extent
wood_fiber_clipped <- createExtent(wood_fiber_data, extent)
oil_palm_concessions_clipped <- createExtent(oil_palm_concessions, extent)
oil_palm_plantations_clipped <- createExtent(oil_palm_plantations, extent)


### OIL PALM ###
mismatches_oil_palm <- Identify_mismatch_polygons(oil_palm_plantations_clipped, oil_palm_concessions_clipped)
stats_oil_palm <- Statistics(mismatches_oil_palm)






# Identifying mismatches between concessions and plantations
mismatches <- mask(plantations_clipped, concessions_clipped, inverse = TRUE)
mismatches_polygons <- as.polygons(mismatches)

# If mismatches_polygons is terra SpatVector, convert to sf-object and cast to
# singlepart polygons
polygons_sf <- st_as_sf(mismatches_polygons)
polygons_sf <- st_cast(polygons_sf, "POLYGON")

# Calculate area in square meters
polygons_sf$area_m2 <- as.numeric(st_area(polygons_sf))

# Filter polygons with area >= 10000 m² (100 pixels)
filtered_polygons_sf <- polygons_sf[polygons_sf$area_m2 >= 10000, ]

#General statistics, respectively: nr. of polygons, total area (m²), 
#mean area (m²), standard deviation of area (m²)
n_polygons <- nrow(filtered_polygons_sf)
total_area <- sum(filtered_polygons_sf$area_m2)
mean_area <- mean(filtered_polygons_sf$area_m2)
sd_area <- sd(filtered_polygons_sf$area_m2)

# Statistics
cat("Number of polygons:", n_polygons, "\n")
cat("Total area (m²):", total_area, "\n")
cat("Mean polygon area (m²):", mean_area, "\n")
cat("Standard deviation of polygon area (m²):", sd_area, "\n")
cat ("Number of football fields:", total_area/7140, "\n")


###
###
###
#potentially use/remove
# Write GeoJSON of filtered polygons
st_write(filtered_polygons_sf, "output/filtered_polygons_oilpalm.geojson")


