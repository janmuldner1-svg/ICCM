# Creating function that clips oil palm concessions and plantations to the extent
source("R/extent.R")
source("R/downloadFiles.R")

library(sf)
library(terra)

boundary <- download_and_extract_Kayong()
download_oil_palm_concessions()

oil_palm_concessions <- st_read("data/palm_tree_concessions.json")
oil_palm_plantations <- rast("data/ketapang_palm_2023_90.tif")

sf_use_s2(FALSE)

#concessions_clipped <- createExtent("data/palm_tree_concessions.json","data/Kayong_boundary.geojson")
concessions_clipped <- st_intersection(oil_palm_concessions, boundary)

spatvector <- vect(boundary)

plantations_clipped <- mask(oil_palm_plantations, spatvector)

# Creating function that identifies mismatch between concessions and plantations
#function()

mismatches <- mask(plantations_clipped, concessions_clipped, inverse = TRUE)
plot(mismatches)
plot(concessions_clipped)
plot(plantations_clipped)

writeRaster(mismatches,"output/mtest.tif", overwrite = TRUE)
