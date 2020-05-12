library(here)
library(glue)
library(jsonlite)
library(dplyr)
library(tidyr)

##### parameters to change -----------------------------------------------------

# also need to update clean_single_file signature

version <- "2020-04-10"

##### don't touch --------------------------------------------------------------

json_paths <- list.files(
  here(glue("data/{version}/json/")),
  full.names = TRUE
)

handler <- function(df) {
  df <- select(df, fieldsOfStudy)
  df <- unnest(df, fieldsOfStudy)
  df <- distinct(df)
  stream_out(df)
}

for (path in json_paths) {

  stream_in(
    file(path),
    handler = handler,
    pagesize = 20000
  )

}

