#Install necessary packages
library(sf)

#Load the concession data
oil_palm_concessions <- st_read("data/palm_tree_concessions.json")
timber_concessions <- st_read("data/timber_concession.json")

combine_concessions <- function (oil_palm_concessions, timber_concessions){
  # Combines the oil palm concession data and the timber concession data into one file.
  # Only writes the combined concessions file to the data folder if it does not exist yet.
  # Requires the oil palm concessions as a json file and the timber concessions as a json file as input
  # Returns a combined concessions json file. 
  
  # Extract the geometries 
  oil_palm_concessions_geom <- st_geometry(oil_palm_concessions)
  timber_concessions_geom <- st_geometry(timber_concessions)
  
  # Make sure the extracted geometries are valid
  oil_palm_concessions_geom <- st_make_valid(oil_palm_concessions_geom)
  timber_concessions_geom <- st_make_valid(timber_concessions_geom)
  
  # Combine the geometries
  concessions_combined <- c(oil_palm_concessions_geom, timber_concessions_geom)
  
  # Write the combined concessions into a json file if it does not already exist
  if(!file.exists("data/concessions_combined.json")){
  st_write(concessions_combined, "data/concessions_combined.json", driver="GeoJSON")
  }
  
}

# #Load the concession data
# oil_palm_concessions <- st_read("data/palm_tree_concessions.json")
# timber_concessions <- st_read("data/timber_concession.json")
# 
# g1 <- st_read("data/palm_tree_concessions.json")
# g2 <- st_read("data/timber_concession.json")
# 
# # Extract only geometries
# g1_geom <- st_geometry(g1)
# g2_geom <- st_geometry(g2)
# 
# g1_geom <- st_make_valid(g1_geom)
# g2_geom <- st_make_valid(g2_geom)
# 
# # Combine the geometries
# concessions_combined <- c(g1_geom, g2_geom)
# 
# st_write(concessions_combined, "data/concessions_combined.json", driver="GeoJSON")