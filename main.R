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

# Download the official timber and oil palm concession data 
download_and_extract_Kayong()
extent <- "data/Kayong_boundary.geojson"

download_wood_fiber_concessions()
wood_fiber_data = "data/wood_fiber_data.json"

oil_palm_concessions <- st_read("data/palm_tree_concessions.json")
oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")

# Limit areas of dataset to the extent
wood_fiber_clipped <- createExtent(wood_fiber_data, extent)
concessions_clipped <- createExtent(oil_palm_concessions, boundary)


### OIL PALM ###
spatvector <- vect(boundary)

plantations_clipped <- mask(oil_palm_plantations, spatvector)

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
st_write(filtered_polygons_sf, "output/filtered_polygons.geojson")

# Write mismatches to tif
writeRaster(mismatches,"output/mismatches.tif", overwrite = TRUE)
