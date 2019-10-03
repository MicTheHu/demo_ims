datenaufbereitung <- function(data) {
  if (!is.null(data)) {
    # Take complete data sets only
    data <- data[data$submitdate != "" & !is.na(data$submitdate),]
    # Prepare position
    data$position <- factor(data$position,
                            levels = c("Professor/Associate Professor", "Postdoc", "Predoc (PhD student)", 
                                       "Scientific Assistant (Project Assistant, ...)", "Other (System administration, Secretary, ...)"),
                            labels = c("(Asso.) Prof.", "Postdoc", "Predoc", "Sci. Assis.", "Other"))
    # Add censoring status
    data$Status <- ifelse(data$dropout == "no", "dropout", "cens")
    # Add survival object
    data$SurvObj <- with(data, Surv(Dienstjahre, Status == "dropout"))
  } else {
    data <- data.frame(
      "id" = integer(),
      "submitdate" = character(),
      "lastpage" = integer(),
      "startlanguage" = character(),
      "datestamp" = character(),
      "Dienstjahre" = integer(),
      "position" = character(),
      "dropout" = integer()
    )
  }
  return(data)
}

# Overwrite limer functions
base64_to_df <- function(x, sep=";") {
  raw_csv <- rawToChar(base64enc::base64decode(x))
  return(read.csv(textConnection(raw_csv), stringsAsFactors = FALSE, sep = sep))
}
get_responses <- function(iSurveyID, sDocumentType = "csv", sLanguageCode = NULL,
                          sCompletionStatus = "complete", sHeadingType = "code",
                          sResponseType = "long", sep=";", ...) {
  # Put all the function's arguments in a list to then be passed to call_limer()
  params <- as.list(environment())
  dots <- list(...)
  if(length(dots) > 0) params <- append(params,dots)
  # print(params) # uncomment to debug the params
  
  results <- call_limer(method = "export_responses", params = params)
  return(base64_to_df(unlist(results), sep=sep))
}
