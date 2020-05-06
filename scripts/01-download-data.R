library(here)
library(glue)
library(jsonlite)

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

for (file in setdiff(manifest, "license.txt")) {

  url <- glue("{base_url}/{version}/{file}")
  destination <- here(glue("data-raw/{version}/{file}"))

  if (!file.exists(destination)) {
    download.file(url, destination)
  }
}

con <- url("http://1usagov.measuredvoice.com/bitly_archive/usagov_bitly_data2013-05-17-1368832207.gz")
mydata <- jsonlite::stream_in(gzcon(con))
