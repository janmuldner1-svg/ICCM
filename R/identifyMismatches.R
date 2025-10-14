# Creating function that clips oil palm concessions and plantations to the extent

Identify_mismatch_polygons <- function(commodities_clipped, concessions_clipped){
  # Function that identifies the mismatch polygons with an area equal or above
  # 10.000 square meters and gives this as output. The function requires data
  # of a commodity (e.g. the oil palm plantations) and the clipped concessions
  # (e.g. the concessions of oil palm with implemented extent).
  
  sf_use_s2(FALSE)
  
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





