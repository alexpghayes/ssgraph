library(here)
library(glue)
library(jsonlite)
library(future)
library(progressr)
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
  df <- stream_in(gzfile(raw_data_paths[index]))
  clean_data_path <- here(glue("data/{version}/{file_names[index]}.rds"))
  readr::write_rds(df, clean_data_path)
}

x <- seq_along(raw_data_paths)

with_progress({
  p <- progressor(along = x)

  future_map(x, ~{

    clean_single_file(.x)
    p()
  })
})

plan(sequential)
