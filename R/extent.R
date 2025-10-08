library(sf)


createExtent <- function(data, extent, output_path = NULL) {
  # Setting the extent of the data to the shape of the extent provided. Requires 
  # the data and extent as input. it's optional to give the outputfile path as 
  # well if you want to save the output. The output is the data cropped to the
  # shape of the shapefile as output.

  
  # Check if CRS matches, transform if necessary
  if (st_crs(data) != st_crs(extent)) {
    message("Transforming CRS to match shapefile CRS")
    data <- st_transform(data, st_crs(extent))
  }
  
  # Crop data to extent
  cropped_data <- st_intersection(data, extent)
  
  # Save cropped data if output_path is provided and file does not exist
  if (!is.null(output_path)) {
    if (file.exists(output_path)) {
      message("Output file already exists, skipping save: ", output_path)
    } else {
      st_write(cropped_data, output_path, delete_dsn = FALSE)
      message("Cropped data saved to: ", output_path)
    }
  }
  
  # Return cropped data
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

