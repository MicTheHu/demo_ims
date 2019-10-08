#####################################################
# Symposium IMS - Shiny Demo
# October 2019
# shinyServer File
#####################################################

# Loading packages
library(devtools)
# Limer not available yet for newest R version, install github version
# install_github("cloudyr/limer")
library(limer)
library(ggplot2)
library(scales)
library(survival)
library(survminer)

# Source R functions
source("functions/ts_data_preparation.R", local = TRUE)
source("functions/data_preparation.R", local = TRUE)
source("functions/limer_update.R", local = TRUE)

# Source credentials: lime_user, lime_pw, api_url and survey_id (not on github)
source("credentials.R", local = TRUE)

shinyServer(function(input, output, session) {
  
  # Enhance shiny with java script functionality
  shinyjs::useShinyjs(html = TRUE)

  # Access Options for LimeSurvey (defined in credentials.R)
  options(lime_api = api_url)
  options(lime_username = lime_user)
  options(lime_password = lime_pw)
  
  # LimeSurvey Log in
  get_session_key()

  # Initialise Reactive Values
  RV <- reactiveValues(data = NULL, ts_data = NULL, autoupdate_interval = NULL)

  # Initialise Progress bar
  t <- 0
  progress <- Progress$new(session, min = 0, max = 10)
  progress$set(message = "Automatic Update")

  # First time loading of LimeSurvey data via limer
  responses <- tryCatch(
    get_responses(
      survey_id,
      sDocumentType = "csv",
      sCompletionStatus = "all",
      sHeadingType = "code",
      sResponseType = "long"
    ),
    error = function(e) NULL
  )

  if (!is.null(responses)) {
    if (nrow(responses) == 0) {
      responses <- NULL
    }
  }

  # Data Preparation
  RV$data <- data_preparation(responses)
  RV$ts_data <- ts_data_preparation(responses)

  # OUTPUTS
  source("timeseries.R", local = TRUE)
  source("hist.R", local = TRUE)
  source("survival.R", local = TRUE)

  # INPUTS
  source("input_progress.R", local = TRUE)
  source("input_options.R", local = TRUE)
  
})
