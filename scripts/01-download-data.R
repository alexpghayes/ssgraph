library(here)
library(glue)
library(jsonlite)
library(furrr)
library(progressr)
library(furrr)

plan(multisession, parallel::detectCores() - 1)

##### parameters to change -----------------------------------------------------

version <- "2020-04-10"

##### don't touch --------------------------------------------------------------

base_url <- "https://s3-us-west-2.amazonaws.com/ai2-s2-research-public/open-corpus"

manifest_url <- glue("{base_url}/{version}/manifest.txt")
manifest_path <- here(glue("data-raw/{version}/manifest.txt"))

if (!file.exists(manifest_path)) {
  download.file(manifest_url, manifest_path)
}

manifest <- readLines(manifest_path)

os <- Sys.info()['sysname']

if (os == "Windows") {
  manifest <- c("sample-S2-records.gz", "license.txt")
}

data_files <- setdiff(manifest, "license.txt")

download_file <- function(file) {
  url <- glue("{base_url}/{version}/{file}")
  destination <- here(glue("data-raw/{version}/{file}"))

  if (!file.exists(destination)) {
    download.file(url, destination)
  }
}

with_progress({
  p <- progressor(along = data_files)

  future_map(data_files, ~{
    download_file(.x)
    p()
  })
})

plan(sequential)
