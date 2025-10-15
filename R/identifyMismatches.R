# Creating function that clips oil palm concessions and plantations to the extent

Identify_mismatch_polygons <- function(commodities_clipped, concessions_clipped){
  # Function that identifies mismatch polygons between commodity data and clipped concessions.
  # Computes the difference between commodity polygons and concession boundaries,
  # converts to single-part polygons, calculates areas in m², and filters for mismatches >= 10,000 m² 
  # (equivalent to 100 pixels). Disables s2 geometry engine for compatibility with masking operation.
  #
  # Input:
  #   commodities_clipped: SpatRaster or sf object representing commodity data 
  #                       (e.g., oil palm plantations) already clipped to study area
  #   concessions_clipped:SpatRaster or sf object representing concession boundaries 
  #                      clipped to the same extent as commodities
  # Output:
  #   sf object containing single-part POLYGON geometries of mismatch areas >= 10,000 m²,
  #   with additional 'area_m2' column containing calculated polygon areas
  
  sf_use_s2(FALSE) # source used for this line: https://stackoverflow.com/questions/79343873/cropping-in-sf-flat-space-vs-spherical-geometry-and-sf-use-s2
  
  # Identifying mismatches between concessions and commodities
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





