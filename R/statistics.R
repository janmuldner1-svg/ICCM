Statistics <- function (filtered_polygons_sf){
  #General statistics, calculates respectively: nr. of polygons, total area (m²), 
  #mean area (m²), standard deviation of area (m²), and puts this (respectively) 
  #into a dataframe where m² is converted to km². Requires the data with
  #filtered polygons as an sf object as input. 
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