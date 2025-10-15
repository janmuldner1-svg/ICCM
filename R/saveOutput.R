save_output <- function(data, filename, output_dir = "output") {
  # Function that checks whether a file already exists in the output directory.
  # If the file doesn't exist, it saves the data as .geojson (using st_write) 
  # or .csv (using write.csv) based on filename extension. If the file already 
  # exists, it prints a message but doesn't overwrite. Other file types are 
  # not supported.
  # 
  # Input:
  #   data: data to save (sf object for .geojson, data.frame for .csv)
  #   filename: character string with filename including .geojson or .csv extension
  #   output_dir: directory to save to (default: "output")
  # 
  # Output:
  #   The full path to the output file (whether saved or already existing)
  
  # Construct full file path
  full_path <- file.path(output_dir, filename)
  
  # Check if file already exists
  if (file.exists(full_path)) {
    message("File already exists: ", basename(full_path))
    return(full_path)
  }
  
  # Check file extension
  file_ext <- tools::file_ext(filename) #source used for this line: https://www.rdocumentation.org/packages/xfun/versions/0.11/topics/file_ext
  
  if (file_ext == "geojson") {
    st_write(data, full_path, quiet = TRUE)
    message("Saved: ", basename(full_path))
    
  } else if (file_ext == "csv") {
    write.csv(data, full_path, row.names = FALSE)
    message("Saved: ", basename(full_path))
    
  } else {
    message("Unsupported file type: ", file_ext, 
            ". Only .geojson and .csv are supported.")
  }
  return(full_path)
}