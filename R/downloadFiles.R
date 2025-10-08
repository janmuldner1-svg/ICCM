## File for downloading necessary datasets

# Packages
library(sf)
library(dplyr)

# Download the boundaries of Kayong Utara regency as extent (project ROI)
download_and_extract_Kayong <- function() {
  # Define URL and destination path
  adm2_URL <- 'https://github.com/wmgeolab/geoBoundaries/raw/9469f09/releaseData/gbOpen/IDN/ADM2/geoBoundaries-IDN-ADM2_simplified.geojson'
  dest_folder <- "data"
  destfile <- file.path(dest_folder, "geoBoundaries-IDN-ADM2_simplified.geojson")
  outputfile <- file.path(dest_folder, "Kayong_boundary.geojson")
  
  if (!dir.exists(dest_folder)) dir.create(dest_folder)
  if (!file.exists(destfile)) download.file(adm2_URL, destfile, mode = "wb")
  
  # Load full GeoJSON into R as sf object
  adm2 <- sf::st_read(destfile, quiet = TRUE)
  
  # Filter dataset to only keep row with Kayong Utara
  kayong <- dplyr::filter(adm2, shapeName == "Kayong Utara")
  
  # Stop code if there is no Kayong Utara row (to prevent it from breaking)
  if (nrow(kayong) == 0) return(NULL)
  
  # Save Kayong boundary as new .geojson
  sf::st_write(kayong, outputfile, delete_dsn = TRUE, quiet = TRUE)
  # Remove the original file with all regencies, return Kayong boundary
  file.remove(destfile)
  return(kayong)
}

# Download the timber concession data
download_timber_concessions <- function(){
  # Download managed forest concessions
  data_managed_forest_URL <- 'https://data.globalforestwatch.org/documents/221fee51bc6047dd929182215c738512'
  
  if (!file.exists('data/managed_forest_data.zip')) {
    download.file(url = data_managed_forest_URL, destfile = 'data/managed_forest_data.zip', mode = "wb")
    unzip('data/managed_forest_data.zip', exdir = 'data')
  }
  
  # Download wood fiber concessions
  data_wood_fiber_URL <- "http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
  
  if(!file.exists('data/wood_fiber_data')){
    download.file(url = data_wood_fiber_URL, "data/wood_fiber_data.json")
  }
  
}

# Download the oil palm concession data
download_oil_palm_concessions <- function(){
  data_oil_palm_URL <- 'https://hub.arcgis.com/api/v3/datasets/f82b539b9b2f495e853670ddc3f0ce68_2/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1'
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, "data/oil_palm_data.json")
  }
}
download_and_extract_Kayong()
# Forest loss dataset in MS Teams
# Oil palm dataset? 
