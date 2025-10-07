<<<<<<< HEAD
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
=======
install.packages("arrow")
library(arrow)
>>>>>>> f268ab9b98e0e2558bc0d019cae7d63cb427f3d2

# Download the timber concession data
download_timber_concessions <- function(){
  # Download managed forest concessions
  #data_managed_forest_URL <- 'https://data.globalforestwatch.org/documents/221fee51bc6047dd929182215c738512'
  
  #if (!file.exists('data/managed_forest_data.zip')) {
    #download.file(url = data_managed_forest_URL, destfile = 'data/managed_forest_data.zip', mode = "wb")
    #unzip('data/managed_forest_data.zip', exdir = 'data')
  #}
  
  # Download wood fiber concessions
  #data_wood_fiber_URL <- "http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
  
  #if(!file.exists('data/wood_fiber_data')){
    #download.file(url = data_wood_fiber_URL, "data/wood_fiber_data.json")
  #}
  
  # Download timber concessions
  data_timber_concession_URL <- 'https://storage.googleapis.com/gee-ramiqcom-s4g-bucket/forestasi_indonesia/vector/tree_plantation_indonesia_v2.parquet'
  
  if(!file.exists('data/timber_concessions_data.parquet')){
    curl::curl_download(url = data_timber_concession_URL, destfile = 'data/timber_concessions_data.parquet', mode = "wb")
    #download.file(url = data_timber_concession_URL, 'data/timber_concessions_data.parquet', mode = 'wb', method = 'libcurl')
  }
  df <- read_parquet('data/timber_concessions_data.parquet')
}

# Download the oil palm concession data
download_oil_palm_concessions <- function(){
  data_oil_palm_URL <- 'http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/2/query?where=1%3D1&outFields=*&outSR=4326&f=json'
  temp <- tempfile(fileext = '.parquet')
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, 'data/oil_palm_data.json')
  }

}

# Forest loss dataset in MS Teams
# Oil palm dataset? 


