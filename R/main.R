# import packages


# Create necessary directories
if(!dir.exists("tempfiles")){dir.create("tempfiles")}
if(!dir.exists("data")){dir.create("data")}
if(!dir.exists("output")){dir.create("output")}

# Source the download function
source("downloadFiles.R")

# Download the official timber and oil palm concession data
download_timber_concessions()
download_oil_palm_concessions()


