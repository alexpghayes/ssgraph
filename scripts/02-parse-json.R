library(here)
library(glue)
library(jsonlite)
library(furrr)
library(stringr)

plan(multisession, workers = parallel::detectCores() - 1)

##### parameters to change -----------------------------------------------------

version <- "2020-04-10"

##### don't touch --------------------------------------------------------------

raw_data_paths <- list.files(
  here(glue("data-raw/{version}/")),
  pattern = "gz",
  full.names = TRUE
)

file_names <- raw_data_paths %>%
  str_remove(paste0(here(glue("data-raw/{version}")), "/")) %>%
  str_remove(".gz")

clean_single_file <- function(raw_path, name) {

  clean_data_path <- here(glue("data/{version}/{name}.rds"))

  if (!file.exists(clean_data_path)) {
    df <- stream_in(gzfile(raw_path))
    readr::write_rds(df, clean_data_path)
  }
}

future_map2(raw_data_paths, file_names, clean_single_file)

plan(sequential)
