library(sf)
library(terra)

Statistics <- function(filtered_polygons_sf, reference_polygons_sf_or_raster = NULL) {
  # Function to calculate mismatch statistics including percentage mismatch relative to reference area.
  #
  # Inputs:
  # - filtered_polygons_sf: sf object of mismatched polygons with 'area_m2' column
  # - reference_polygons_sf_or_raster: sf polygons or SpatRaster for reference area calculation (optional)
  #
  # Output: data.frame with columns:
  # "Number of Mismatches", "Total Mismatch Area in km²", "Mean Mismatch Area in km²",
  # "SD Mismatch Area in km²", "Football Field Equivalent", 
  # "Mismatch Area as part of Total Area in Percentage(%)"
  
  # Calculate mismatch stats
  n_polygons <- nrow(filtered_polygons_sf)
  total_area <- sum(filtered_polygons_sf$area_m2, na.rm = TRUE)
  mean_area <- mean(filtered_polygons_sf$area_m2, na.rm = TRUE)
  sd_area <- sd(filtered_polygons_sf$area_m2, na.rm = TRUE)
  n_football_fields <- total_area / 7140  # Approximate football field area in m²
  
  # Initialize percentage mismatch as NA
  perc_mismatch <- NA_real_
  
  # Calculate total reference area based on input type
  if (!is.null(reference_polygons_sf_or_raster)) {
    if (inherits(reference_polygons_sf_or_raster, "SpatRaster")) {
      # Reproject raster to UTM zone 49S (EPSG:32749) for meter-based units
      reference_projected <- terra::project(reference_polygons_sf_or_raster, "EPSG:32749")
      
      # Calculate cell area in m²
      res_vals <- terra::res(reference_projected)
      cell_area <- res_vals[1] * res_vals[2]
      
      # Count valid (non-NA) cells
      vals <- terra::values(reference_projected)
      valid_cells <- sum(!is.na(vals))
      
      total_reference_area <- valid_cells * cell_area
      
    } else if (inherits(reference_polygons_sf_or_raster, "sf")) {
      # Polygon sf: check for 'area_m2' or 'shape_Area' column
      if ("area_m2" %in% colnames(reference_polygons_sf_or_raster)) {
        total_reference_area <- sum(reference_polygons_sf_or_raster$area_m2, na.rm = TRUE)
      } else if ("shape_Area" %in% colnames(reference_polygons_sf_or_raster)) {
        total_reference_area <- sum(reference_polygons_sf_or_raster$shape_Area, na.rm = TRUE)
      } else {
        stop("The 'reference_polygons_sf_or_raster' sf object must contain 'area_m2' or 'shape_Area' column.")
      }
    } else {
      stop("The 'reference_polygons_sf_or_raster' input must be either an sf object or a SpatRaster.")
    }
    
    # Calculate percentage mismatch relative to total reference area
    if (!is.na(total_reference_area) && total_reference_area > 0) {
      perc_mismatch <- (total_area / total_reference_area) * 100
    }
  }
  
  # Prepare output dataframe
  stats_df <- data.frame(
    n_polygons = n_polygons,
    total_area_km2 = total_area / 1e6,
    mean_area_km2 = mean_area / 1e6,
    sd_area_km2 = sd_area / 1e6,
    n_football_fields = n_football_fields,
    percentage_mismatch = perc_mismatch
  )
  
  # Rename columns to user-friendly names
  names(stats_df) <- c(
    "Number of Mismatches",
    "Total Mismatch Area in km²",
    "Mean Mismatch Area in km²",
    "SD Mismatch Area in km²",
    "Football Field Equivalent",
    "Mismatch Area as part of Total Area in Percentage(%)"
  )
  
  return(stats_df)
}
