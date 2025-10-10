# Creating function that clips oil palm concessions and plantations to the extent
source("R/extent.R")
source("R/downloadFiles.R")

library(sf)
library(terra)
library(dplyr)

# boundary <- download_and_extract_Kayong()
# download_oil_palm_concessions()
# 
# oil_palm_concessions <- st_read("data/palm_tree_concessions.json")
# oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")
# oil_palm_plantations <- mask(oil_palm_plantations, oil_palm_plantations, maskvalues=0)

Identify_mismatch_polygons <- function(commodities_clipped, concessions_clipped){
  # Function that identifies the mismatch polygons with an area equal or above
  # 10.000 square meters and gives this as output. The function requires data
  # of a commodity (e.g. the oil palm plantations) and the clipped concessions
  # (e.g. the concessions of oil palm with implemented extent).
  
  sf_use_s2(FALSE)
  #spatvector <- vect(extent)
  #commodities_clipped <- mask(commodities, spatvector)
  
  # Identifying mismatches between concessions and commodoties
  mismatches <- mask(commodities_clipped, concessions_clipped, inverse = TRUE)
  mismatches_polygons <- as.polygons(mismatches)
  
  # If mismatches_polygons is terra SpatVector, convert to sf-object and cast to
  # singlepart polygons
  polygons_sf <- st_as_sf(mismatches_polygons)
  polygons_sf <- st_cast(polygons_sf, "POLYGON")
  
  # Calculate area in square meters
  polygons_sf$area_m2 <- as.numeric(st_area(polygons_sf))
  
  # Filter polygons with area >= 10.000 m² (100 pixels)
  filtered_polygons_sf <- polygons_sf[polygons_sf$area_m2 >= 10000, ]
  return (filtered_polygons_sf)
}

Statistics <- function (filtered_polygons_sf){
  #General statistics, gives respectively: nr. of polygons, total area (m²), 
  #mean area (m²), standard deviation of area (m²). Requires the data with
  # filtered polygons as an sf object as input. 
  n_polygons <- nrow(filtered_polygons_sf)
  total_area <- sum(filtered_polygons_sf$area_m2)
  mean_area <- mean(filtered_polygons_sf$area_m2)
  sd_area <- sd(filtered_polygons_sf$area_m2)
  
  # Print statistics 
  cat("Number of polygons:", n_polygons, "\n")
  cat("Total area (m²):", total_area, "\n")
  cat("Mean polygon area (m²):", mean_area, "\n")
  cat("Standard deviation of polygon area (m²):", sd_area, "\n")
  cat ("Number of football fields:", total_area/7140, "\n")
  
  return (n_polygons, total_area, mean_area, sd_area)
}



# Write code that will merge (union) all concession polygons that share  a faulty  border
# (Some of the concessions should be connected directly, but they are not in the acquired dataset, thus creating faulty gaps)

# # First, create list of problematic polygons using their pairs IDs
# pairs <- list(
#   c(998, 1055),
#   c(1055, 1211),
#   c(1211, 1054),
#   c(1054, 1000),
#   c(1054, 1213),
#   c(1213, 1000)
# )
# 
# # Function to dissolve pair by union
# dissolved_concessions <- function(oil_palm_concessions, id_col, pairs) {
#   for (pair in pairs) {
#     # Filter polygons for the current pair of IDs (used ChatGPT for assistance)
#     to_union <- oil_palm_concessions %>% filter(!!sym(id_col) %in% pair)
#     # Union the geometries
#     union_geom <- st_union(to_union)
#     # Remove original polygons in pair
#     oil_palm_concessions <- oil_palm_concessions %>% filter(! (!!sym(id_col) %in% pair))
#     # Create a new row with unioned geometry and combined IDs
#     new_row <- to_union[1, ]
#     new_row[[id_col]] <- paste(pair, collapse = "_")
#     st_geometry(new_row) <- union_geom
#     
#     # Add new dissolved polygon back
#     oil_palm_concessions <- rbind(oil_palm_concessions, new_row)
#   }
#   return(oil_palm_concessions)
# }
# 
# # Apply new function
# concessions_fixed <- dissolved_concessions(oil_palm_concessions, "objectid", pairs)
# 
# # Write to new geojson
# st_write(concessions_fixed, "output/concessions_fixed.geojson")


  # Clip the fixed concessions to

##################################################################
############# OLD CODE OUTSIDE FUNCTION ##########################
##################################################################

# concessions_clipped <- createExtent(oil_palm_concessions, boundary)
# 
# spatvector <- vect(boundary)
# 
# plantations_clipped <- mask(oil_palm_plantations, spatvector)

# Creating function that identifies mismatch between concessions and plantations

# mismatches <- mask(plantations_clipped, concessions_clipped, inverse = TRUE)
# plot(mismatches)
# plot(concessions_clipped)
# plot(plantations_clipped)
# 
# writeRaster(mismatches,"output/mtest.tif", overwrite = TRUE)
# 
# mismatches_polygons <- as.polygons(mismatches)
# 
# # If mismatches_polygons is terra SpatVector, convert first:
# polygons_sf <- st_as_sf(mismatches_polygons)
# 
# # Cast to singlepart polygons
# polygons_sf <- st_cast(polygons_sf, "POLYGON")
# 
# # Calculate area in square meters
# polygons_sf$area_m2 <- as.numeric(st_area(polygons_sf))
# 
# # Filter polygons with area >= 10000 m² (100 pixels)
# filtered_polygons_sf <- polygons_sf[polygons_sf$area_m2 >= 10000, ]
# 
# # Write GeoJSON
# st_write(filtered_polygons_sf, "output/filtered_polygons.geojson")
# 
# # Number of polygons
# n_polygons <- nrow(filtered_polygons_sf)
# 
# # Total area (m²)
# total_area <- sum(filtered_polygons_sf$area_m2)
# 
# # Mean area (m²)
# mean_area <- mean(filtered_polygons_sf$area_m2)
# 
# # Standard deviation of area (m²)
# sd_area <- sd(filtered_polygons_sf$area_m2)
# 
# # Statistics
# cat("Number of polygons:", n_polygons, "\n")
# cat("Total area (m²):", total_area, "\n")
# cat("Mean polygon area (m²):", mean_area, "\n")
# cat("Standard deviation of polygon area (m²):", sd_area, "\n")
# 
# total_area / 7140

