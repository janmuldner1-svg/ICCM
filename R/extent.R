load_if_path <- function(input) {
  # Function that loads geospatial data from a file path into appropriate spatial object 
  # (sf for vector, SpatRaster for raster) or returns input unchanged if already an sf or 
  # SpatRaster object. Automatically detects file type based on extension and handles 
  # both file paths (character) and existing spatial objects transparently.
  #
  # Input:
  #   input: character string (file path to geospatial data) OR existing sf object OR SpatRaster object
  # Output:
  #   sf object for vector files (.shp, .geojson, etc.), SpatRaster for raster files (.tif, .tiff),
  #   or unchanged input if already sf/SpatRaster
  #
  #   Groks latest free version (Grok 4) has been used to refine this code. 
  
  if (is.character(input)) {
    # Check file extension to determine if it's a raster or vector
    ext <- tools::file_ext(input)
    message(sprintf("Reading file from: %s", input))
    if (ext %in% c("tif", "tiff")) {
      return(rast(input))
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
  # Function that crops geospatial data (vector or raster) to a specified extent boundary.
  # Supports both sf vector data and SpatRaster raster data, automatically handles CRS 
  # transformation, geometry validation, and conditional file saving. Crops vectors using 
  # spatial intersection and rasters using crop+mask operations.
  #
  # Input:
  #   data: file path to geospatial data (.tif/.tiff/.geojson/.json/.shp) or existing sf/SpatRaster object
  #   extent: file path to vector extent boundary (.geojson/.shp) or existing sf object defining crop boundary
  #   output_path: optional character string for output file path (saves only if file doesn't exist)
  #
  # Output:
  #   Cropped sf object (for vector input) or SpatRaster object (for raster input)
  #   Optionally saves to output_path if provided and file doesn't exist
  
  # Load data and extent if they are file paths
  data <- load_if_path(data)
  extent <- load_if_path(extent)
  
  # Handle vector data
  if (inherits(data, "sf")) {
    # Validate geometries
    data <- st_make_valid(data)
    extent <- st_make_valid(extent)
    
    # Check if CRS matches, transform if necessary
    if (st_crs(data) != st_crs(extent)) {
      message("Transforming CRS to match extents CRS")
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
  
  # Handle raster data
  else if (inherits(data, "SpatRaster")) {
    # Convert extent to SpatVector
    extent_vect <- vect(extent)
    
    # Check if CRS matches, transform if necessary
    if (crs(data) != crs(extent_vect)) {
      message("Transforming raster CRS to match extent CRS")
      data <- project(data, crs(extent_vect))
    }
    
    # Crop raster to extent
    cropped_data <- crop(data, extent_vect)
    cropped_data <- mask(cropped_data, extent_vect)
    
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

