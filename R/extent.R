library(sf)
library(terra)

# Load required packages
library(sf)
library(terra)

load_if_path <- function(input) {
  # Function loads geospatial data from a filepath into an sf or spatraster
  # object, or returns the sf/spatraster object unchanged if its already such
  # an object. 
  if (is.character(input)) {
    # Check file extension to determine if it's a raster or vector
    ext <- tolower(tools::file_ext(input))
    message(sprintf("Reading file from: %s", input))
    if (ext %in% c("tif", "tiff")) {
      return(terra::rast(input))
    } else {
      return(st_read(input, quiet = TRUE))
    }
  } else if (inherits(input, "sf") || inherits(input, "SpatRaster")) {
    return(input)
  } else {
    stop("Input must be a file path (character), an sf-object, or a SpatRaster")
  }
}

createExtent <- function(data, extent, output_path = NULL) {
  # Function crops data to the extent that's provided. It supports vector and 
  # raster (.tiff/.tif) input. 
  # Input:
  #   data: filepath to data accepts .tif/.tiff/.geojson/.json/.shp
  #   extent: file of vector extent (e.g. .geojson)
  #   output_path: optional entry for location the output must be saved to
  # Returns: cropped data as an sf-object or spatraster-object
  

  
  # Load data and extent if they are file paths
  data <- load_if_path(data)
  extent <- load_if_path(extent)
  
  # Handle vector (sf) data
  if (inherits(data, "sf")) {
    # Validate geometries
    data <- st_make_valid(data)
    extent <- st_make_valid(extent)
    
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
        message("Output file already exists, no need for save: ", output_path)
      } else {
        st_write(cropped_data, output_path, delete_dsn = FALSE)
        message("Cropped data saved to: ", output_path)
      }
    }
    return(cropped_data)
  }
  
  # Handle raster (SpatRaster) data
  else if (inherits(data, "SpatRaster")) {
    # Convert extent to SpatVector
    extent_vect <- vect(extent)
    
    # Check if CRS matches, transform if necessary
    if (crs(data) != crs(extent_vect)) {
      message("Transforming raster CRS to match extent CRS")
      data <- project(data, crs(extent_vect))
    }
    
    # Crop raster to extent
    cropped_data <- mask(data, extent_vect)
    
    # Save cropped raster if output_path is provided and file does not exist
    if (!is.null(output_path)) {
      if (file.exists(output_path)) {
        message("Output file already exists, no need for save: ", output_path)
      } else {
        writeRaster(cropped_data, output_path, overwrite = FALSE)
        message("Cropped raster saved to: ", output_path)
      }
    }
    return(cropped_data)
  }
  
  # Stop if data is neither sf- nor spatraster-object
  else {
    stop("Data must be an sf-object or a SpatRaster")
  }
}


# 
# load_if_path <- function(input) {
#   # Function to load data if input is a file path and turns data into sf-object
#   if (is.character(input)) {
#     message(sprintf("Reading file from: %s", input))
#     return(st_read(input, quiet = TRUE))
#   } else if (!inherits(input, "sf")) {
#     stop("Input must be either a file path (character) or an sf-object")
#   } else {
#     return(input)
#   }
# }
# 
# createExtent <- function(data, extent, output_path = NULL) {
#   # Setting the extent of the data to the shape of the extent provided. Requires 
#   # the data and extent as input. it's optional to give the outputfile path as 
#   # well if you want to save the output. The output is the data cropped to the
#   # shape of the shapefile as output.
#   
#   # Load data and extent if they are file paths
#   data <- load_if_path(data)
#   extent <- load_if_path(extent)
#   
#   # Validating data
#   data <- st_make_valid(data)
#   extent <- st_make_valid(extent)
#   
#   # Check if CRS matches, transform if necessary
#   if (st_crs(data) != st_crs(extent)) {
#     message("Transforming CRS to match shapefile CRS")
#     data <- st_transform(data, st_crs(extent))
#   }
#   
#   # Crop data to extent
#   cropped_data <- st_intersection(data, extent)
#   
#   # Save cropped data if output_path is provided and file does not exist
#   if (!is.null(output_path)) {
#     if (file.exists(output_path)) {
#       message("Output file already exists, no need for save: ", output_path)
#     } else {
#       st_write(cropped_data, output_path, delete_dsn = FALSE)
#       message("Cropped data saved to: ", output_path)
#     }
#   }
#   
#   # Return cropped data
#   return(cropped_data)
# }

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

