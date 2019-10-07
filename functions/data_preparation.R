#####################################################
# Symposium IMS - Shiny Demo
# October 2019
# Data preparation
#####################################################

data_preparation <- function(data) {
  if (!is.null(data)) {
    # Take complete data sets only
    data <- data[data$submitdate != "" & !is.na(data$submitdate),]
    # Prepare position
    data$position <- factor(data$position,
                            levels = c("Professor/Associate Professor", "Postdoc", "Predoc (PhD student)", 
                                       "Scientific Assistant (Project Assistant, ...)", "Other (System administration, Secretary, ...)"),
                            labels = c("(Asso.) Prof.", "Postdoc", "Predoc", "Sci. Assis.", "Other"))
    # Add censoring status
    data$Status <- ifelse(data$employed == "no", "dropout", "cens")
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
      "employed" = character()
    )
  }
  return(data)
}
