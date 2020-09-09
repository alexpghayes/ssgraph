library(here)
library(glue)
library(furrr)
library(dplyr)
library(jsonlite)

plan(multisession, workers = min(parallel::detectCores() - 1, 24))

##### parameters to change -----------------------------------------------------

# also need to update clean_single_file signature

version <- "2020-04-10"

##### don't touch --------------------------------------------------------------

raw_data_paths <- list.files(
  here(glue("data-raw/{version}/")),
  pattern = "gz",
  full.names = TRUE
)

file_names <- raw_data_paths %>%
  stringr::str_remove(paste0(here(glue("data-raw/{version}")), "/")) %>%
  stringr::str_remove(".gz")

process_single_file <- function(raw_path, name, version = "2020-04-10") {

  clean_data_path <- here(glue("output/{version}/journalName/{name}.json"))

  handler <- function(df) {
    df <- select(df, journalName)
    df <- unnest(df, c(journalName))
    df <- distinct(df)
    stream_out(df, clean_data_con)
  }

  if (!file.exists(clean_data_path)) {

    clean_data_con <- file(clean_data_path, open = "wb")
    on.exit(close(clean_data_con))

    stream_in(
      gzfile(raw_path),
      handler = handler,
      pagesize = 20000
    )
  }
}

future_map2(raw_data_paths, file_names, process_single_file)

plan(sequential)

