# library(limer)
library(devtools)
load_all("C:/Users/themessl-huberm/git_projects/MUW/functions/limer-master")
library(ggplot2)
library(scales)
library(survival)
library(survminer)

source("credentials.R", local = TRUE)
source("functions/datenaufbereitung.R", local = TRUE)
source("functions/ts_datenaufbereitung.R", local = TRUE)

shinyServer(function(input, output, session) {
  
  # Enhance shiny with java script functionality
  shinyjs::useShinyjs(html = TRUE)

  # Access Options for LimeSurvey
  options(lime_api = api_url)
  options(lime_username = lime_user)
  options(lime_password = lime_pw)
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
      # sLanguageCode = "de",
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
  RV$data <- datenaufbereitung(responses)
  RV$ts_data <- ts_datenaufbereitung(responses)

  # OUTPUTS
  source("timeseries.R", local = TRUE)
  source("hist.R", local = TRUE)
  source("survival.R", local = TRUE)

  # INPUTS
  source("input_fortschritt.R", local = TRUE)
  source("input_options.R", local = TRUE)
  
})
