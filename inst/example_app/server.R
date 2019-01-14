
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {
  data = reactive({
    get(input$sel_dataset)
  })

  pages = reactive({
    nrow_data = nrow(data())
    # rows_per_page = ceiling(nrow_data / input$pager$pages_total)

    row_starts = seq(1, nrow_data, by = input$num_rows_per_page)
    row_stops  = c(row_starts[-1] - 1, nrow_data)

    page_rows = mapply(`:`, row_starts, row_stops, SIMPLIFY=F)

    return(page_rows)
  })

  output$debug = renderPrint({
    str(input$pager)
  })

  output$table = renderTable({
    Sys.sleep(input$num_page_delay)
    data = data()
    rows = pages()[[input$pager$page_current]]

    data[rows,]
  })

  observeEvent(
    eventExpr = {
      c(input$num_rows_per_page, input$sel_dataset)
    },
    handlerExpr = {

      pages_total = ceiling(nrow(data()) / input$num_rows_per_page)

      page_current = input$pager$page_current
      if (input$pager$page_current > pages_total) {
        page_current = pages_total
      }

      updatePageruiInput(
        session, 'pager',
        page_current = page_current,
        pages_total = pages_total
      )
    }
  )

})
