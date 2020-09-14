library(here)
library(glue)
library(tidyverse)
library(RVerbalExpressions)
library(stringr)

version <- "2020-04-10"

all_journals <- read_csv(
  here(glue("output/{version}/all_journals.csv"))
)

want <- rx() %>%
  rx_either_of(
    c(
      "statistic",
      "probability",
      "stochastic",
      "random",
      "biometrik",
      "multivariate",
      "econometric",
      "bayes",
      "time series",
      "the r journal",
      "bernoulli"
    )
  )

dont_want <- rx() %>%
  rx_either_of(
    c(
      "JP journal of biostatistics",
      "Revista brasileira de estatistica",
      "digest",
      "note",
      "bulletin",
      "quarterly",
      "review",
      "vital",
      "healthy"
    )
  )

to_use <- all_journals %>%
  filter(str_detect(journalName, want)) %>%
  filter(!str_detect(journalName, dont_want))

# datapasta::df_paste(to_use)

allowed_journals <- c(
  "Statistics & probability letters",
  "Electronic journal of statistics",
  "The annals of applied statistics",
  "Computational statistics & data analysis",
  "Journal of the Royal Statistical Society. Series C, Applied statistics",
  "Biostatistics",
  "Journal of computational and graphical statistics : a joint publication of American Statistical Association, Institute of Mathematical Statistics, Interface Foundation of North America",
  "Journal of biopharmaceutical statistics",
  "The British journal of mathematical and statistical psychology",
  "Pharmaceutical statistics",
  "Journal of statistical planning and inference",
  "Biostatistics (Oxford, England)",
  "Scandinavian journal of statistics, theory and applications",
  "Journal of epidemiology and biostatistics",
  "Journal of multivariate analysis",
  "Technometrics : a journal of statistics for the physical, chemical, and engineering sciences",
  "The International Journal of Biostatistics",
  "Journal of biometrics & biostatistics",
  "Journal of econometrics",
  "The Canadian journal of statistics = Revue canadienne de statistique",
  "Communications in statistics: theory and methods",
  "Journal of statistical software",
  "Advances in applied probability",
  "Spatial statistics",
  "Journal of applied statistics",
  "Journal of nonparametric statistics",
  "Communications in statistics: Simulation and computation",
  "Journal of statistical research",
  "Communications for statistical applications and methods",
  "Law, probability & risk : a journal of reasoning under uncertainty",
  "Journal of statistical computation and simulation",
  "Frontiers in applied mathematics and statistics",
  "Journal of applied probability",
  "Electronic journal of probability",
  "Epidemiology, biostatistics and public health",
  "Journal of time series analysis",
  "The Australian journal of statistics",
  "International journal of statistics in medical research",
  "Computational statistics",
  "Biostatistics & epidemiology",
  "Advances and applications in statistics",
  "Journal of survey statistics and methodology",
  "Biostatistics and biometrics open access journal",
  "Model assisted statistics and applications : an international journal",
  "Journal of mathematics and statistics",
  "Journal of modern applied statistical methods : JMASM",
  "Journal of agricultural, biological, and environmental statistics",
  "International journal of clinical biostatistics and biometrics",
  "Advances in statistical climatology, meteorology and oceanography",
  "Journal of statistics education : an international journal on the teaching and learning of statistics",
  "Computational Intelligence Methods for Bioinformatics and Biostatistics",
  "Epidemiological and vital statistics report. Rapport epidemiologique et demographique",
  "Journal of applied econometrics",
  "Econometrics and statistics",
  "The annals of applied probability : an official journal of the Institute of Mathematical Statistics",
  "Journal of probability and statistics",
  "Communications in statistics. Case studies, data analysis and applications",
  "Annals of economics and statistics",
  "International journal of statistics and probability",
  "Journal of statistical science and application",
  "The international journal of biostatistics",
  "Frontiers of Biostatistical Methods and Applications in Clinical Oncology",
  "Open access medical statistics",
  "Journal of statistical mechanics",
  "Teaching statistics",
  "Biometrics & biostatistics international journal",
  "African statistical journal = Journal statistique africain",
  "Journal of algebraic statistics",
  "Applied stochastic models in business and industry",
  "American journal of applied mathematics and statistics",
  "Journal of applied probability and statistics",
  "Biostatistics, bioinformatics and biomathematics",
  "Journal of statistical theory and applications : JSTA",
  "Annals of biometrics & biostatistics",
  "Journal of business & economic statistics : a publication of the American Statistical Association",
  "Combinatorics, probability & computing : CPC",
  "The econometrics journal",
  "Australian & New Zealand journal of statistics",
  "Open journal of statistics",
  "Chilean journal of statistics",
  "Journal of applied statistical science",
  "International journal of statistics and applications",
  "Journal of statistics applications & probability",
  "Computational intelligence methods for bioinformatics and biostatistics : 13th International Meeting, CIBB 2016, Stirling, UK, September 1-3, 2016, Revised selected papers. CIBB (Meeting)",
  "Journal of medical statistics and informatics",
  "Journal of statistical theory and practice",
  "Annals of probability"
)

write_rds(
  allowed_journals,
  here(glue("output/{version}/allowed_journals.rds"))
)
