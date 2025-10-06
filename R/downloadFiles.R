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
  data_oil_palm_URL <- 'http://gis-gfw.wri.org/arcgis/rest/services/country_data/asia/MapServer/2/query?where=1%3D1&outFields=*&outSR=4326&f=json'
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, "data/oil_palm_data.json")
  }
}



