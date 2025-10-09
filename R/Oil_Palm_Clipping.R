# Creating function that clips oil palm concessions and plantations to the extent
source("R/extent.R")
source("R/downloadFiles.R")

library(sf)
library(terra)

boundary <- download_and_extract_Kayong()
download_oil_palm_concessions()

oil_palm_concessions <- st_read("data/palm_tree_concessions.json")
oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")

sf_use_s2(FALSE)

concessions_clipped <- st_intersection(oil_palm_concessions, boundary)

spatvector <- vect(boundary)

plantations_clipped <- mask(oil_palm_plantations, spatvector)

# Creating function that identifies mismatch between concessions and plantations

mismatches <- mask(plantations_clipped, concessions_clipped, inverse = TRUE)
plot(mismatches)
plot(concessions_clipped)
plot(plantations_clipped)

writeRaster(mismatches,"output/mtest.tif", overwrite = TRUE)

mismatches_polygons <- as.polygons(mismatches)

# If mismatches_polygons is terra SpatVector, convert first:
polygons_sf <- st_as_sf(mismatches_polygons)

# Cast to singlepart polygons
polygons_sf <- st_cast(polygons_sf, "POLYGON")

# Calculate area in square meters
polygons_sf$area_m2 <- as.numeric(st_area(polygons_sf))

# Filter polygons with area >= 10000 m² (100 pixels)
filtered_polygons_sf <- polygons_sf[polygons_sf$area_m2 >= 10000, ]

# Write GeoJSON
st_write(filtered_polygons_sf, "output/filtered_polygons.geojson")

# Statistics
cat("Number of mismatch polygons:", nrow(filtered_polygons_sf), "\n")
cat("Total area (m2):", sum(filtered_polygons_sf$area_m2), "\n")
cat("Total area (km2):", sum(filtered_polygons_sf$area_m2) / 1000000, "\n")

# Number of polygons
n_polygons <- nrow(filtered_polygons_sf)

# Total area (m²)
total_area <- sum(filtered_polygons_sf$area_m2)

# Mean area (m²)
mean_area <- mean(filtered_polygons_sf$area_m2)

# Standard deviation of area (m²)
sd_area <- sd(filtered_polygons_sf$area_m2)

# Print nicely
cat("Number of polygons:", n_polygons, "\n")
cat("Total area (m²):", total_area, "\n")
cat("Mean polygon area (m²):", mean_area, "\n")
cat("Standard deviation of polygon area (m²):", sd_area, "\n")

total_area / 7140

