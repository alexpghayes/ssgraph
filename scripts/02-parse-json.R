library(here)
library(glue)
library(jsonlite)
library(furrr)
library(stringr)
library(dplyr)

plan(multicore, workers = min(parallel::detectCores() - 1, 6))

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

clean_single_file <- function(raw_path, name, pg = 500) {

  clean_data_path <- here(glue("data/{version}/json/{name}.json"))
  clean_data_con <- file(clean_data_path)

  handler <- function(df) {
    df <- filter(df, map_dbl(inCitations, length) > 0)
    df <- select(df, -c(entities:pmid), -c(s2Url:authors), -pdfUrls, -sources, -doiUrl, -venue)
    stream_out(df, file(clean_data_path), pagesize = pg)
  }

  if (!file.exists(clean_data_path)) {
    stream_in(
      gzfile(raw_path),
      handler = handler,
      pagesize = pg
    )
  }
}

clean_single_file(raw_data_paths, file_names)

future_map2(raw_data_paths, file_names, clean_single_file)

plan(sequential)
