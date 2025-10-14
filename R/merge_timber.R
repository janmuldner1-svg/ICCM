# File to merge the managed forest data set and the wood fiber data set into one timber concession file

# Packages 
library(sf)

merge_timber <- function(managed_forest_clipped, wood_fiber_clipped){
  # Function to combine the wood fiber and managed forest data into one timber concessions file
  # Only writes the combined timber concessions to file if it does not already exist
  # Accepts a spatial raster, spatial vector, spatial raster data set or spatial vector collection as input
  # Returns the combined timber concessions as a .geojson file
  
  # Combine the two cropped spatial datasets using rbind()
  combined_concessions <- rbind(managed_forest_clipped, wood_fiber_clipped)
  
  # Write the combined GeoJSON to file if it does not already exist
  if(!file.exists("data/timber_concessions.geojson")){
  st_write(combined_concessions, "data/timber_concessions.geojson", driver = "GeoJSON", delete_dsn = TRUE)
  }
}


