observeEvent(input$grouping_enable, {
  RV$grouping_enable <- input$grouping_enable
})
observeEvent(input$density_enable, {
  RV$density_enable <- input$density_enable
})

output$hist_plot <- renderPlot({
  req(RV$data)
  req(RV$plot_base_size)
  if (nrow(RV$data) >= 2) {
    # Grouping on/off
    if (RV$grouping_enable) {
      p <- ggplot(RV$data[!is.na(RV$data$Dienstjahre),], 
                  aes(x = Dienstjahre, fill = position)) +
        theme_minimal(base_size = RV$plot_base_size) +
        theme(legend.title = element_blank(),
              legend.spacing.x = unit(0.2, 'cm'),
              legend.justification = c(1, 1),
              legend.position = c(1.00, 1.00)) +
        scale_fill_manual(values = c("(Asso.) Prof." = "#fbb900", 
                                     "Postdoc" = "#ec6623", 
                                     "Predoc" = "#b7087f", 
                                     "Sci. Assis." = "#00a3a6", 
                                     "Other" = "#506482"))
      
    } else {
      p <- ggplot(RV$data[!is.na(RV$data$Dienstjahre),], aes(x = Dienstjahre)) +
        theme_minimal(base_size = RV$plot_base_size)
    }
    # Density or Bars
    if (RV$density_enable) {
      if (!RV$grouping_enable) {
        p <- p + geom_density(aes(y = ..density..), alpha = 0.3, size = 1, fill = "lightgrey")
      } else {
        p <- p + geom_density(aes(y = ..density..), alpha = 0.3, size = 1)
      }
      p <- p + scale_x_continuous("Years of Service", 
                                  limits = c(0, max(RV$data$Dienstjahre, na.rm = TRUE) + 1),
                                  breaks = seq(from = 0, to = max(RV$data$Dienstjahre, na.rm = TRUE), by = 2)) +
        scale_y_continuous("Density")
    } else {
      p <- p + geom_histogram(aes(y = ..count..), binwidth = 1) +
        scale_x_continuous("Years of Service", 
                           limits = c(-0.5, max(RV$data$Dienstjahre, na.rm = TRUE) + 1),
                           breaks = seq(from = 0, to = max(RV$data$Dienstjahre, na.rm = TRUE), by = 2)) +
        scale_y_continuous("Count")
    }
    print(p)
  }
})
