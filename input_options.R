# Font size in Figures
observeEvent(input$plot_base_size, {
  RV$plot_base_size <- input$plot_base_size
})

# Eventlistener Autoupdate (Settings)
observeEvent(input$autoupdate_interval, {
  RV$autoupdate_interval <- input$autoupdate_interval
})

# Eventlistener: Show Figure Polls
observeEvent(input$show_plot1, {
  shinyjs::toggleElement("plotwrapper_polls", condition = input$show_plot1)
})

# Eventlistener: Show Figure Distribution
observeEvent(input$show_plot2, {
  shinyjs::toggleElement("plotwrapper_hist", condition = input$show_plot2)
})

# Eventlistener: Show Figure Kaplan-Meier
observeEvent(input$show_plot3, {
  shinyjs::toggleElement("plotwrapper_km", condition = input$show_plot3)
})
