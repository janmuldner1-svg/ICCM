# import packages
if(!"sf" %in% installed.packages()){install.packages("sf")}
library(sits)


# Create necessary directories
if(!dir.exists("tempfiles")){dir.create("tempfiles")}
if(!dir.exists("data")){dir.create("data")}
if(!dir.exists("output")){dir.create("output")}

# Source the download function
source("R/downloadFiles.R")
source("R/extent.R")

# Download the official timber and oil palm concession data
download_and_extract_Kayong()
download_timber_concessions()
download_oil_palm_concessions()


#Example code to run extent on wood fiber data with kayong boundary as extent
extent = "data/Kayong_boundary.geojson"
wood_fiber_data = "data/wood_fiber_data.json"
test <- createExtent(wood_fiber_data, extent)
plot(test)
