library(sf)
g1 <- st_read("data/palm_tree_concessions.json")
g2 <- st_read("data/timber_concession.json")

# Extract only geometries
g1_geom <- st_geometry(g1)
g2_geom <- st_geometry(g2)

g1_geom <- st_make_valid(g1_geom)
g2_geom <- st_make_valid(g2_geom)

# Combine the geometries
concessions_combined <- c(g1_geom, g2_geom)

st_write(concessions_combined, "data/concessions_combined.json", driver="GeoJSON")