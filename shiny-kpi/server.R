library(shiny)
library(shinydashboard)

shinyServer(function(input, output) {
  set.seed(123)
  histdata <- rnorm(500)
  
  output$dashboard.plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$res <- renderText({
    req(input$sidebarItemExpanded)
    paste("Expanded menuItem:", input$sidebarItemExpanded)
  })
  
  observeEvent(input$csvValidator, {
    tryCatch(
      {
        df <- read.csv(
          input$toBeUploaded$datapath,
          header = input$existHeader,
          skip = input$skipIndex,
          sep = input$csvSeparator,
          quote = input$csvQuoter
        )
        output$csvuploader.preview <- DT::renderDataTable({
          DT::datatable(df)
        })
      },
      error = function(e) {
        # return a safeError
        output$csvuploader.message <- "WHAAAAAAAAAAAAAAAAT??????!?!?!"
        geterrmessage()
        stop()
      })
  })
})
