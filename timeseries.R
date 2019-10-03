output$ts_plot <- renderPlot({
  req(RV$ts_data)
  req(RV$plot_base_size)
  if (nrow(RV$ts_data) > 2) {
    p <- ggplot(RV$ts_data, aes(x = datestamp, y = cumsum, group = complete)) +
      geom_hline(yintercept = 0, colour = "#9E9E9E") +
      geom_step(aes(colour = complete), size = 2, direction = "hv") +
      scale_colour_manual(values = c("grey", "#03A9F4"), breaks = c("complete", "incomplete"), name = NULL) +
      scale_y_continuous(limits = c(0, max(unique(floor(pretty(seq(0, (max(RV$ts_data$cumsum) + 1) * 1.1)))))), #max(RV$ts_data$cumsum)),
                         breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1))))) +
      theme_minimal(base_size = RV$plot_base_size) +
      labs(
        y = "Number of submitted polls",
        x = "Date/Time"
      ) +
      theme(
        legend.justification = c(1, 0),
        legend.position = c(0.15, 0.85)
      )
      print(p)
  }
})
