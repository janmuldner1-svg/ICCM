# combine_concessions.R
#' Combine Two Concession Data Frames
#'
#' This function takes two data frames—typically parsed from JSON sources—
#' and combines them into one by row-binding. It handles differences in
#' columns by automatically filling missing values with `NA`.

library(dplyr)

concessions_combined <- function(json1, json2) {
  combined <- bind_rows(json1, json2)
  return(combined)
}
