#####################################################
# Symposium IMS - Shiny Demo
# October 2019
# Kaplan-Meier Estimator and plot
#####################################################

output$survival <- renderPlot({
  req(RV$data)
  req(RV$plot_base_size)
  if (nrow(RV$data) >= 2) {
    if (RV$grouping_enable) {
      # Calculate Kaplan-Meier Estimator with predictor position
      km.by.pos <- survfit(SurvObj ~ position, data = RV$data, conf.type = "log-log")
      
      # Draw Kaplan-Meier plot
      ggsurvplot(fit = km.by.pos, 
                 data = RV$data, 
                 size = 1.5,
                 conf.int = FALSE,
                 # pval = TRUE,
                 risk.table = TRUE,
                 risk.table.y.text = FALSE,
                 censor.shape = "|", 
                 censor.size = 8,
                 risk.table.height = 0.35,
                 # surv.median.line = "hv", # add the median survival pointer
                 break.time.by = 4,  
				 alpha = 0.7,
                 xlab = "Years of Service",
                 ylab = "Probability of employment",
                 palette = c("(Asso.) Prof." = "#fbb900", 
                             "Postdoc" = "#ec6623", 
                             "Predoc" = "#b7087f", 
                             "Sci. Assis." = "#00a3a6", 
                             "Other" = "#506482"),
                 legend.labs = levels(RV$data$position)[levels(RV$data$position) %in% unique(na.omit(RV$data$position))],
                 ggtheme = theme_minimal(base_size = RV$plot_base_size))
      
    } else {
      
      # Calculate Kaplan-Meier Estimator without predictors
      km.as.one <- survfit(SurvObj ~ 1, data = RV$data, conf.type = "log-log")
      
      # Draw Kaplan-Meier plot
      # plot(km.as.one, mark.time = TRUE)
      ggsurvplot(fit = km.as.one, 
                 data = RV$data, 
                 size = 2,
                 conf.int = TRUE,
                 # pval = TRUE,
                 risk.table = TRUE,
                 censor.shape = "|", 
                 censor.size = 8,
                 risk.table.height = 0.25,
                 surv.median.line = "hv",  # add the median survival pointer.
                 break.time.by = 4,  
                 xlab = "Years of Service",
                 ylab = "Probability of employment",
                 ggtheme = theme_minimal(base_size = RV$plot_base_size))
    }
  }
})

