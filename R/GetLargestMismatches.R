#' Get the Largest Mismatches by Area
#'
#' This function selects the top `n` rows from a spatial dataframe (sf object)
#' ordered by the largest values in the `area_m2` column.
#'
get_largest_mismatches <- function(sf_object, top_n = 10) {
  sf_object %>%
    arrange(desc(area_m2)) %>%
    slice_head(n = top_n)
}
