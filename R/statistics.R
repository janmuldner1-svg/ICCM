Statistics <- function (filtered_polygons_sf){
  # Function that calculates general statistics for an sf object containing polygons.
  # Computes: number of polygons, total area (in m²), mean area (in m²), and 
  # standard deviation of area (in m²). Puts this information in a dataframe 
  # (which is there converted to km² if applicable)
  # Uses sf geometry operations to calculate areas and summary statistics.
  #
  # Input:
  #   sf_data: sf object containing filtered polygons with valid geometry
  #
  # Output:
  #   data.frame with columns: n_polygons, total_area_km2, mean_area_km2, sd_area_km2

  n_polygons <- nrow(filtered_polygons_sf)
  total_area <- sum(filtered_polygons_sf$area_m2)
  mean_area <- mean(filtered_polygons_sf$area_m2)
  sd_area <- sd(filtered_polygons_sf$area_m2)
  n_football_fields <- total_area / 7140
  
  stats_df <- data.frame(
    n_polygons = n_polygons,
    total_area_km2 = total_area/1000000,
    mean_area_km2 = mean_area/1000000,
    sd_area_km2 = sd_area/1000000,
    n_football_fields = n_football_fields
  )
  
  return (stats_df)
}