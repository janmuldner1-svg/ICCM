# File to merge the managed forest data set and the wood fiber data set into one timber concession file

merge_timber <- function(managed_forest_clipped, wood_fiber_clipped){
  # Function that combines managed forest and wood fiber concession datasets into a single 
  # timber concessions file. Merges two spatial datasets and writes the result
  # as a Geojson file only if the output file does not already exist. Prevents overwriting 
  # existing data to avoid accidental data loss.
  #
  # Input:
  #   managed_forest_clipped: sf object or compatible spatial vector representing 
  #                          clipped managed forest concession boundaries
  #   wood_fiber_clipped: sf object or compatible spatial vector representing 
  #                      clipped wood fiber concession boundaries
  # Output:
  #   Writes combined timber concessions to "data/timber_concessions.geojson" 
  #   if file doesn't exist. No return value.
  
  # Combine the two cropped spatial datasets using rbind()
  combined_concessions <- rbind(managed_forest_clipped, wood_fiber_clipped)
  
  # Write the combined GeoJSON to file if it does not already exist
  if(!file.exists("data/timber_concessions.geojson")){
  st_write(combined_concessions, "data/timber_concessions.geojson", driver = "GeoJSON", delete_dsn = TRUE)
  }
}


