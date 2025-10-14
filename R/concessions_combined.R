# combine_concessions.R
library(dplyr)

concessions_combined <- function(json1, json2) {
  combined <- bind_rows(json1, json2)
  return(combined)
}
