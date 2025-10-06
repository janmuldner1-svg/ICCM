# Download the timber concession data
download_timber_concessions <- function(){
  # Download managed forest concessions
  data_managed_forest_URL <- 'https://gfw-data-lake.s3.amazonaws.com/gfw_logging_download/v2020/vector/epsg-4326/gfw_logging_download_v2020.shp.zip?AWSAccessKeyId=ASIAV3FRM4Z6AH6NZPNZ&Signature=q5Gs3LFWKpLEDWj2GnrrgZJXdT0%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEPX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIQCXM3IhnpuV02DtXIvwZkgGK%2B7JeTlLUHJq3uVkitBuMgIgfEgPrun1nvuLn2nS3XWvCNtg9o38OePOq8UbfS1w4pwqiAQIjv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARADGgw0MDE5NTE0ODM1MTYiDOWrjufVXNsYbjpl6CrcA0Baw9JZAw%2F%2BOYhLSscEJwY63QblaSuKiiZt2lRMCRjlFk8%2BY3bFVczP55w3A2tjXUlLotvoFNulWF8WuZH3VfATuaBIBZGi5n3USJUMEHJFxlpb9bS4j46%2FvLLxscia%2F8DUT48fHgrzz%2BqhO1F4I6wEsiLz7qY0IArxPq71OWLq%2By9KWNi7OuSP4Gxw%2B3QVphPRzM1WMwGgo1d6xRlh2FNENAtYoO0N08k%2FCGfRD8fH3sDFBXRPE12bGFBhmRp8nXsuR7THrFIAc9y7t4PN4iFKvZCEtpj7UlRXmMdXHqfp7BTFpkLuOKqCd6RuZ7LyBt%2Fihrmo5S7LJEEitOt0P7pvFnOiLQCIFWCPY2%2BumszbvNf2THgOqCnie9HQGpBQdKblSeGGUXi6cZ2EJ7Xu%2BQo0%2FbgkpZ323Vz1JtiXd5N9uLlyrKDPBcFnjt2dvccxVlN59xa3BNGIOayAEqxNwJalxiW0WI4QMZI7PW6FEurY8xbtyubVgoJqiDXtWBryEF3%2FJlXGb4zzHLXn0okCkGvAUxUqDdVT1cL4Upn%2B8PszkbLE%2BM%2FYh%2B%2FZNU3NAh0Ogx93sNhM3Gvd4Gi2cYHoLycXmrpPWpZUizC1BMBfA9GkF%2BXDWevmame%2FicCNMM7ujscGOqUBryZjvakZPIQvcslmSUOjgMau56Hj9wu4XlxZEE9MBsYW62BzNRTJOWttrnCqr9ndivp60WnFSB13DEoBWUqoj9AMz%2FvMh4gcj5iPOeXufTh7c6ukMSIZl8%2FwLyqj4G2bLb0qPQFGxMZjYQsVBWIi3D%2Bu9g3FHaPWTAQ0RnEIin8qa3yuSFa6Z2Rj7PLCFiPqLwqX9rKjD3hzk34RltX5NWuZ%2FbOM&Expires=1759760676'
  
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



