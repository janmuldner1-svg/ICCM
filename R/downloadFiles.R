## File for downloading necessary datasets

# Packages
library(sf)
library(dplyr)

download_and_extract_Kayong <- function() {
  # Download the boundaries of Kayong Utara regency as extent (project ROI), 
  # only execute the download if the data is not downloaded yet. 
  # Requires no input, the output is a geojson file called 
  # Kayong_boundary.geojson in the data-folder
  
  # Define URL and destination path
  adm2_URL <- 'https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/IDN/ADM2/geoBoundaries-IDN-ADM2_simplified.geojson'
  dest_folder <- "data"
  outputfile <- file.path(dest_folder, "Kayong_boundary.geojson")
  
  if(!file.exists('data/Kayong_boundary.geojson')){
    download.file(url = adm2_URL, "data/Kayong_boundary.geojson", mode = "wb")
  }
}


download_wood_fiber_concessions <- function(){
  # Download the concessions of wood fiber. 
  # only execute the download if the data is not downloaded yet. 
  # Requires no input, the output is a json file called 
  # wood_fiber_data.json in the data-folder
  
  data_wood_fiber_URL <- "http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
  
  if(!file.exists('data/wood_fiber_data')){
    download.file(url = data_wood_fiber_URL, "data/wood_fiber_data.json")
  }
}


download_oil_palm_concessions <- function(){
  # Download the concessions of oil palms. 
  # only execute the download if the data is not downloaded yet. 
  # Requires no input, the output is a json file called 
  # palm_tree_concessions.json in the data-folder
  data_oil_palm_URL <- 'https://hub.arcgis.com/api/v3/datasets/f82b539b9b2f495e853670ddc3f0ce68_2/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1'
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, "data/palm_tree_concessions.json")
  }
}


