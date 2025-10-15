get_largest_mismatches <- function(sf_object, top_n = 10) {
  # Function that selects the top n largest mismatch polygons from an sf object 
  # based on area_m2 column values. Orders polygons by descending area and extracts 
  # the first n rows.
  #
  # Input:
  #   sf_object: sf object containing mismatch polygons with 'area_m2' column 
  #              (typically output from Identify_mismatch_polygons function)
  #   top_n: integer specifying number of largest polygons to return (default: 10)
  # Output:
  #   sf object containing the top n polygons with largest area_m2 values, ordered by descending area
  
  sf_object %>%
    arrange(desc(area_m2)) %>%
    slice_head(n = top_n)
}

