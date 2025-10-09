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
  # Temporary link, needs replacement before 9 Oct, 2027
  data_managed_forest_URL <- 'https://gfw-data-lake.s3.amazonaws.com/gfw_logging_download/v2020/vector/epsg-4326/gfw_logging_download_v2020.shp.zip?AWSAccessKeyId=ASIAV3FRM4Z6I6OQP2NY&Signature=fRPqz1Qw5NsgyX8NnlYqu3YMrkg%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEDoaCXVzLWVhc3QtMSJIMEYCIQDV3tyxJXM98bMAGtlE%2B9aBprEiBmEf%2FF7DJvKC6L4K0AIhAJfzkkZLLvd9mJHmM07%2Fv0532bIWD30IfMeG5GTfeu6fKogECNP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQAxoMNDAxOTUxNDgzNTE2Igzj0K%2FWnKZlltz1mWEq3AN8Xqc7l6DiN9W9J4UFq4um4XlQ2LNPiQMJbMW7FP%2ByXXc2E3gCtHAVb2hUHLKph89BEGwuFm%2BChc4CBE%2FnxuBNrAiH3Vt40ELYdJD%2Bn0UZSsft0cE9tR9%2F%2FgHhkgOsGO%2FQNi3BzM1Bgg2V7y26kZyuCYAki9lFfRpkbQwSa55s%2BCfO7Ufg4hkHzgISroiWK2hdGzOYOgssmrss4mkiCPOPUTwp22gWSXUKxuQljmm2iFj%2FXc7Xpufm9%2BwLQIP2BmgcQkaJWSh%2BqO%2F%2Fkw2FJ2nfy456VFUnLim96yC7l3mpDtxA1gCZ4RdOVvjSI%2BuXXcEXjy9ApoqqcyynSynrSWvfd1i8OoLse770ggpsv0pZeUa0KrtiMFP2byvJQee0ZDBOsAHGJBeKcrqz991XYFo7ApBL5hPWc54hWaRN6gC3nM5p7k8ZIMpI2uQPIGRBdMFbZIOSDRIqWVmm6%2B26mUgC%2BaeA1Su%2B2%2BDYC75WamTATdWZe2uBBwhNuSy8sbKVXMN7TJJ5AupKYTiL4BQxwjMFWKYuQWilX%2BMgnAPImUztOdQk2JiynfWfe2XkOTUw6wb9dXbeDMkeDLoz9nbUAlPA2LTofvT8HrXaUtY6tJ%2F7GQwA4T%2FCyomJIKQOGzCkjp7HBjqkAXiJGKnBSo6MAUF%2Br3Ojl%2BqpBexWeV9NxJ6foV5m1rbxrl6FWlajM6jFF9ISSN24lIyG77F%2FmofQI%2FPT1tTHrPwaU0dqxe6h019DYZwhw4zqcxxQ9GC%2FUodPpRbB76is3%2BPVeygXwsMa0BTkrCA4ut18FjBcpqLki9IVURR5cn8AgxpSht3XtXLBFSqh3SMraXM1i8FZPLnsnN5SmAlxQAo4qnhP&Expires=1760015782'
  
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

#links for managed forest, please leave these for comparison in case link breaks again
#data_managed_forest_URL <- 'https://gfw-data-lake.s3.amazonaws.com/gfw_logging_download/v2020/vector/epsg-4326/gfw_logging_download_v2020.shp.zip?AWSAccessKeyId=ASIAV3FRM4Z6JUNNBJOR&Signature=yiMMILaiS8s8QiTymUVSRMAsXqk%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEDgaCXVzLWVhc3QtMSJHMEUCIEqtTEPWSRTti8dIIODsZ6mV20%2FbjO6nr7HtDbSelmLyAiEAuyOeNcCW%2FNLmF3gd0N8AWee4PX7adv5eBvPPMq24aMEqiAQI0f%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARADGgw0MDE5NTE0ODM1MTYiDEIA6K8J9ht5KebeSyrcA2GRslSuNwiZjc5Hs4lQSzATmWM7hqnjkI8u2%2Ben0GxIpycUCDczQNR0eB%2FBAYdJhNNorXZRvOOkcgYGmViwkIITmF35C1yz6sWuthRYmh5wvWuM%2FQQaFnxkbpPWkMBiPArTpwfUG6rr0aPUNvTZWBkSPEGZP2%2Bb3P8UWWG6mqzHyf%2BVwm2GnX3SYtdw17mVvyPRvOh1%2BWBbc%2B4VJJp%2BUybAbn2alIrun09aKC5Um9LyuWFgst5nWqHfauaUr%2BxJZKRvpCc9y8B0I00LC0sEPmGV16cht%2BMcDSF%2FnyKvaNlc5ZJDhg9irFXEFHPrlpTMdxD6zqGeNHxVo5C87rVojqktOMJWeAODte5bq4Wi4RrER32SrjqxBVh0YLBoGmXCBijvoQ3ljOTcBVDMkydl8PPl%2FJxivwQQcjoN8ZPnLgYCiht1AFTs98DnuQ%2FtEUP0Q7Py9UIeabSEv%2Fbf3vKymk%2FILyBSvUUCIpIPUPPNyleqa%2FpuxJqDRYm0MIqJy%2F84N36takxlwpUm8jtXTJ0AnW5MJaC6ipcGP2LHBAOsrvh1UqP%2FtiU6FfJMQ9i4qIpgh2NZzzc8MZDpxNG7AioQPxdn5s4lJmBdXDZPrEPOpx7TfSRgKtZge9FE6e7eMIXInccGOqUB586aVC4WF78lY10NDdgNqcaFd3uRgIkamkT2A8m%2FpbP9mEmcZ9HeCujLma5UXQzgyOwfPqDmO5cBR6o061tz6rwqgtUcRML2k%2FXr7Ptu1oRqKTeHhZ4qBftHGSxGNhN0Xj2lErSikSSoWkCjhpG2Jbcf8AdQwb9OCZloHbK7Liaxgu2RVg25rmw8EHcD6pVQSBNkMJIw0BqzbDkcMwNLdSirheeN&Expires=1760010792'
#data_url2 <- 'https://gfw-data-lake.s3.amazonaws.com/gfw_logging_download/v2020/vector/epsg-4326/gfw_logging_download_v2020.shp.zip?AWSAccessKeyId=ASIAV3FRM4Z6JUNNBJOR&Signature=uYEWaz4x%2BjxIqerhTKr2RX%2Bfq88%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEDgaCXVzLWVhc3QtMSJHMEUCIEqtTEPWSRTti8dIIODsZ6mV20%2FbjO6nr7HtDbSelmLyAiEAuyOeNcCW%2FNLmF3gd0N8AWee4PX7adv5eBvPPMq24aMEqiAQI0f%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARADGgw0MDE5NTE0ODM1MTYiDEIA6K8J9ht5KebeSyrcA2GRslSuNwiZjc5Hs4lQSzATmWM7hqnjkI8u2%2Ben0GxIpycUCDczQNR0eB%2FBAYdJhNNorXZRvOOkcgYGmViwkIITmF35C1yz6sWuthRYmh5wvWuM%2FQQaFnxkbpPWkMBiPArTpwfUG6rr0aPUNvTZWBkSPEGZP2%2Bb3P8UWWG6mqzHyf%2BVwm2GnX3SYtdw17mVvyPRvOh1%2BWBbc%2B4VJJp%2BUybAbn2alIrun09aKC5Um9LyuWFgst5nWqHfauaUr%2BxJZKRvpCc9y8B0I00LC0sEPmGV16cht%2BMcDSF%2FnyKvaNlc5ZJDhg9irFXEFHPrlpTMdxD6zqGeNHxVo5C87rVojqktOMJWeAODte5bq4Wi4RrER32SrjqxBVh0YLBoGmXCBijvoQ3ljOTcBVDMkydl8PPl%2FJxivwQQcjoN8ZPnLgYCiht1AFTs98DnuQ%2FtEUP0Q7Py9UIeabSEv%2Fbf3vKymk%2FILyBSvUUCIpIPUPPNyleqa%2FpuxJqDRYm0MIqJy%2F84N36takxlwpUm8jtXTJ0AnW5MJaC6ipcGP2LHBAOsrvh1UqP%2FtiU6FfJMQ9i4qIpgh2NZzzc8MZDpxNG7AioQPxdn5s4lJmBdXDZPrEPOpx7TfSRgKtZge9FE6e7eMIXInccGOqUB586aVC4WF78lY10NDdgNqcaFd3uRgIkamkT2A8m%2FpbP9mEmcZ9HeCujLma5UXQzgyOwfPqDmO5cBR6o061tz6rwqgtUcRML2k%2FXr7Ptu1oRqKTeHhZ4qBftHGSxGNhN0Xj2lErSikSSoWkCjhpG2Jbcf8AdQwb9OCZloHbK7Liaxgu2RVg25rmw8EHcD6pVQSBNkMJIw0BqzbDkcMwNLdSirheeN&Expires=1760013797'


# Download the oil palm concession data
download_oil_palm_concessions <- function(){
  data_oil_palm_URL <- 'https://hub.arcgis.com/api/v3/datasets/f82b539b9b2f495e853670ddc3f0ce68_2/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1'
  
  if(!file.exists('data/oil_palm_data')){
    download.file(url = data_oil_palm_URL, "data/palm_tree_concessions.json")
  }
}

# Forest loss dataset in MS Teams
# Oil palm dataset? 
