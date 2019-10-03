# Automatic Logins in LimeSurvey, not to get logged out
# only every 10 minutes
observe({
  if (input$autoupdate_enable == TRUE) {
    invalidateLater(6e+05, session)
    get_session_key()  # limesurvey Log in
  }
})

# Automatic Updates
observe({
  req(RV$autoupdate_interval)
  if (input$autoupdate_enable == TRUE) {
    invalidateLater(RV$autoupdate_interval * 100, session)
    t <<- t + 1

    if (t > 10) {
      RV$zeit <- strftime(Sys.time(), "%d.%m.%Y %H:%M:%S")
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
      RV$data <- datenaufbereitung(responses)
      RV$ts_data <- ts_datenaufbereitung(responses)

      t <<- 0

    }
    progress$set(t)
  }
})
