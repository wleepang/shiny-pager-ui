
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source('pagerui.R')

shinyUI(fluidPage(

  # Application title
  titlePanel("Pager UI Widget"),

  fluidRow(
    column(
      width = 2,
      numericInput('num_page_current', 'Set Current Page', value = 1, min = 1)
    ),
    column(
      width = 2,
      numericInput('num_pages_total', 'Set Total Pages', value = 0, min = 0)
    ),
    column(
      width = 1,
      actionButton('btn_update', 'Update')
    )
  ),

  fluidRow(
    column(
      width = 12,
      hr(),
      pageruiInput('pager', 1, 50),
      hr(),
      verbatimTextOutput('debug')
    )
  )

))
