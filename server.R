
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {

  output$debug <- renderPrint({
    input$pager
  })

  observeEvent(
    eventExpr = {
      input$btn_update
    },
    handlerExpr = {
      updatePageruiInput(
        session, 'pager',
        page_current = input$num_page_current,
        pages_total = input$num_pages_total
      )
    }
  )

})
