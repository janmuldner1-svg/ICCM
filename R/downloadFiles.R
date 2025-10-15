## File for downloading necessary datasets

download_and_extract_Kayong <- function(adm2_URL) {
  # Function that downloads Indonesia's second-level administrative boundaries 
  # using a provided URL, extracts the boundary polygon for Kayong Utara 
  # (the roi), and saves it as a Geojson file. Skips download and extraction 
  # if the output file already exists to avoid redundant operations. Uses hardcoded regency 
  # name for filtering after downloading the file.
  #
  # Input:
  #   url: character string specifying the download URL for roi at administration level 2 
  #
  # Output:
  #   sf object containing the single polygon or multipolygon geometry for Kayong Utara
  #   boundary, saved to "data/Kayong_boundary.geojson" if not already present
  
  # Define URL and destination paths
  dest_folder <- "data"
  temp_folder <- "tempfiles"
  temp_file <- file.path(temp_folder, "IDN_ADM2.geojson")
  outputfile <- file.path(dest_folder, "Kayong_boundary.geojson")
  
  # Check if file exists already
  if (!file.exists(outputfile)) {
    # Download the full ADM2 geojson if needed
    download.file(url = adm2_URL, destfile = temp_file, mode = "wb")
    
    # Read the full ADM2 .geojson
    indonesia_adm2 <- st_read(temp_file, quiet = TRUE)
    
    # Filter to Kayong Utara only
    kayong_utara <- indonesia_adm2[indonesia_adm2$shapeName == "Kayong Utara", ]
    
    # Save filtered data to output file
    st_write(kayong_utara, outputfile, driver = "GeoJSON", delete_dsn = TRUE)
    
    # Delete the temp ADM2 file to clean up
    file.remove(temp_file)
  }
}


download_wood_fiber_concessions <- function(data_wood_fiber_URL){
  # Function that downloads wood fiber concessions data from a specified URL source,
  # extracts concessions, and saves as a json file. Skips download and extraction if the output file 
  # already exist to avoid redundant downloading. 
  #
  # Input:
  #   data_wood_fiber_URL: character string specifying the download URL for wood fiber 
  #                       concessions data 
  # Output:
  #   sf object containing polygon or multipolygon geometries for wood fiber concessions,
  #   saved to "data/wood_fiber_data.json" if not already present
  
  if(!file.exists('data/wood_fiber_data')){
    download.file(url = data_wood_fiber_URL, "data/wood_fiber_data.json")
  }
}

download_oil_palm_concessions <- function(data_oil_palm_URL){
  # Function that downloads oil palm concessions data from a specified URL source,
  # saving as a json file. Only executes the download if the output file 
  # does not already exist to avoid redundant downloads.
  #
  # Input:
  #   data_oil_palm_URL: character string specifying the download URL for oil palm 
  #                     concessions data (JSON format)
  #
  # Output:
  #   Raw json file "data/palm_tree_concessions.json" containing oil palm concessions data,
  #   downloaded only if file missing. 
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, "data/palm_tree_concessions.json")
  }
}


