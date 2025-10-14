## File for downloading necessary datasets

# Packages
library(sf)
library(dplyr)

# Function that downloads the second administration level of Indonesia, 
# extracting the boundary of Kayong Utara (a single regency) as output.
# Only executes the download, if the data is not downloaded already.
# Requires no input, the output is a .geojson file called 
# "Kayong_boundary.geojson" in the "data" directory.

download_and_extract_Kayong <- function() {
  
  # Define URL and destination paths
  adm2_URL <- 'https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/IDN/ADM2/geoBoundaries-IDN-ADM2_simplified.geojson'
  dest_folder <- "data"
  temp_folder <- "tempfiles"
  temp_file <- file.path(temp_folder, "IDN_ADM2.geojson")
  outputfile <- file.path(dest_folder, "Kayong_boundary.geojson")
  
  # Check if file exists already
  if (!file.exists(outputfile)) {
    # Download the full ADM2 geojson if needed
    download.file(url = adm2_URL, destfile = temp_file, mode = "wb")
    
    # Read the full ADM2 .geojson
    indonesia_adm2 <- sf::st_read(temp_file, quiet = TRUE)
    
    # Filter to Kayong Utara only
    kayong_utara <- indonesia_adm2[indonesia_adm2$shapeName == "Kayong Utara", ]
    
    # Save filtered data to output file
    sf::st_write(kayong_utara, outputfile, driver = "GeoJSON", delete_dsn = TRUE)
    
    # Delete the temp ADM2 file to clean up
    file.remove(temp_file)
  }
}

# Function that downloads the concessions of wood fiber,
# only executes if the data is not downloaded yet. 
# Requires no input, the output is a json file called 
# "wood_fiber_data.json" in the "data" directory.

download_wood_fiber_concessions <- function(){
  
  data_wood_fiber_URL <- "http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
  
  if(!file.exists('data/wood_fiber_data')){
    download.file(url = data_wood_fiber_URL, "data/wood_fiber_data.json")
  }
}

# Function that downloads the concessions of oil palms, 
# only executes the download if the data is not downloaded yet. 
# Requires no input, the output is a json file called 
# "palm_tree_concessions.json" in the "data" directory.

download_oil_palm_concessions <- function(){

  data_oil_palm_URL <- 'https://hub.arcgis.com/api/v3/datasets/f82b539b9b2f495e853670ddc3f0ce68_2/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1'
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, "data/palm_tree_concessions.json")
  }
}


