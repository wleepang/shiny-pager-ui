
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Pager UI Widget Demo"),

  fluidRow(
    column(
      width = 2,
      selectInput('sel_dataset', 'Dataset', choices = c('mtcars', 'iris', 'airquality')),
      numericInput('num_rows_per_page', 'Rows Per Page', value = 10, min = 1),
      numericInput('num_page_delay', 'Paging Delay (s)', value = 0, min = 0),
      helpText('Simulates paging with a processing delay - e.g. plotting'),
      hr(),
      verbatimTextOutput('debug'),
      helpText('The data stored in the pager-ui input.')
    ),
    column(
      width = 10,
      pageruiInput('pager', 1, 1),
      hr(),
      tableOutput('table')
    )
  )

))
