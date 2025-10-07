library(sf)

createExtent <- function(data_path, shapefile_path) {
  # Setting the extent of the data to the shape of the shapefile. Requires the
  # data path and shapefile path as input, and will give the data cropped to the
  # shape of the shapefile as output.
  
  data <- st_read(data_path)
  extent <- st_read(shapefile_path)
  
  #Checking whether the CRS is the same, if not convert the crs of the data to 
  #the crs of the shapefile (extent)
  if (st_crs(data) != st_crs(shape)) {
    message("Transforming CRS to match shapefile CRS")
    data <- st_transform(data, st_crs(extent))
  }
  
  cropped_data <- st_intersection(data, extent)
  return(cropped_data)
}