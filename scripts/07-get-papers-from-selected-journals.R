library(here)
library(glue)
library(furrr)
library(tidyverse)
library(jsonlite)
library(stringr)
library(RVerbalExpressions)

plan(multisession, workers = min(parallel::detectCores() - 1, 24))

version <- "2020-04-10"

allowed_journals_vector <- read_rds(
  here(glue("output/{version}/allowed_journals.rds"))
)

allowed_journals <- rx() %>%
  rx_either_of(allowed_journals_vector)

data_paths <- list.files(
  here(glue("data/{version}/json/")),
  pattern = "json",
  full.names = TRUE
)

raw_data_paths <- list.files(
  here(glue("data-raw/{version}/")),
  pattern = "gz",
  full.names = TRUE
)

file_names <- raw_data_paths %>%
  stringr::str_remove(paste0(here(glue("data-raw/{version}")), "/")) %>%
  stringr::str_remove(".gz")

process_single_file <- function(path, name, version = "2020-04-10") {

  clean_data_path <- here(
    glue("data/{version}/allowed_journals_only/{name}.json")
  )

  handler <- function(df) {
    df <- filter(df, str_detect(journalName, allowed_journals))
    stream_out(df, clean_data_con)
  }

  clean_data_con <- file(clean_data_path, open = "wb")
  on.exit(close(clean_data_con))

  stream_in(
    gzfile(path),
    handler = handler,
    pagesize = 20000
  )
}

future_map2(data_paths, file_names, process_single_file)

plan(sequential)
