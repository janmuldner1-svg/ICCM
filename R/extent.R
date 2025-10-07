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

#stolen snippet of code for sentinel data for later
# download_images_and_prepare_data <- function(shapefile_path, start_date, end_date) {
#   # Read the input file
#   roi <- st_read(shapefile_path)
#   
#   # Define the spatial and temporal extent for the sits data cube
#   cube <- sits_cube(
#     source = "MPC",
#     collection = "SENTINEL-2-L2A",
#     roi = roi,
#     start_date = start_date,
#     end_date = end_date,
#     bands = c("B02", "B03", "B04")
#   )
#   
#   # Download the imagery
#   images <- sits_cube_copy(cube, roi = roi, res = 10, output_dir = "data")
#   
#   
#   return(images)
# }

