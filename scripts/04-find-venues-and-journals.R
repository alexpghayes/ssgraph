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

con_out <- file(here("output/journal-names"), open = "wb")

handler <- function(df) {
  df <- select(df, journalName)
  df <- unnest(df, c(journalName))
  df <- distinct(df)
  stream_out(df, con_out)
}

for (path in json_paths) {

  stream_in(
    file(path),
    handler = handler,
    pagesize = 20000
  )
}

# we're gonna go with Mathematics, Computer Science and Economics for now

