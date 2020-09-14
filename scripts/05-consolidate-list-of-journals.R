library(here)
library(glue)
library(dplyr)
library(tidyr)
library(jsonlite)
library(readr)
library(furrr)
plan(multisession, workers = min(parallel::detectCores() - 1, 24))

version <- "2020-04-10"

paths <- list.files(
  here(glue("output/{version}/journalName")),
  pattern = "json",
  full.names = TRUE
)

read_from_path <- function(path) {
  df <- stream_in(file(path))
  as_tibble(distinct(df, journalName))
}

all_journals <- future_map_dfr(paths, read_from_path)

write_csv(
  distinct(all_journals),
  here(glue("output/{version}/all_journals.csv"))
)

plan(sequential)
