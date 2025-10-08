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
