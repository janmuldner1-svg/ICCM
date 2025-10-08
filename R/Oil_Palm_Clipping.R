# Creating function that clips oil palm concessions and plantations to the extent
source("R/extent.R")
source("R/downloadFiles.R")

library(sf)
library(terra)

boundary <- download_and_extract_Kayong()
download_oil_palm_concessions()

oil_palm_concessions <- vect("data/palm_tree_concessions.json")
oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")

concessions_clipped <- createExtent(oil_palm_concessions, boundary, output_path = NULL)
plantations_clipped <- createExtent(oil_palm_plantations, boundary, output_path = NULL)

# Creating function that identifies mismatch between concessions and plantations
#function()

mismatches <- mask(plantations_clipped, concessions_clipped, inverse = TRUE)
plot(mismatches)