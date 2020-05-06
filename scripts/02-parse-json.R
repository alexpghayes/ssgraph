library(here)
library(glue)
library(jsonlite)
library(furrr)

plan(multisession, parallel::detectCores() - 1)

##### parameters to change -----------------------------------------------------

version <- "2020-04-10"

##### don't touch --------------------------------------------------------------

raw_data_paths <- list.files(
  here(glue("data-raw/{version}/")),
  pattern = "gz",
  full.names = TRUE
)

file_names <- stringr::str_remove(
  raw_data_paths,
  paste0(here(glue("data-raw/{version}")), "/")
)

clean_single_file <- function(index) {

  clean_data_path <- here(glue("data/{version}/{file_names[index]}.rds"))

  if (!file.exists(clean_data_path)) {
    df <- stream_in(gzfile(raw_data_paths[index]))
    readr::write_rds(df, clean_data_path)
  }
}

future_map(raw_data_paths, clean_single_file)

plan(sequential)
