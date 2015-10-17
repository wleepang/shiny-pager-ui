pageruiInput = function(inputId, page_current = NULL, pages_total = NULL) {
  # construct the pager-ui framework
  tagList(
    singleton(
      tags$head(
        tags$script(src = 'js/underscore-min.js'),
        # tags$script(HTML(js))
        tags$script(src = 'js/pager-ui.shiny.js')
      )
    ),

    # root pager-ui node
    div(
      id = inputId,
      class = 'pager-ui',

      # reactive numeric input to store current page
      # access it as input[['{{inputId}}__page_current']]
      span(
        class = 'hidden shiny-input-container',
        tags$input(
          id = paste(inputId, 'page_current', sep='__'),
          class = 'page-current',
          type = 'number',
          value = ifelse(!is.null(page_current), page_current, 1),
          min = 1,
          max = ifelse(!is.null(pages_total), pages_total, 1)
        )
      ),

      # reactive numeric input to store total pages
      # access it as input[['{{inputId}}__pages_total']]
      span(
        class = 'hidden shiny-input-container',
        tags$input(
          id = paste(inputId, 'pages_total', sep='__'),
          class = 'pages-total',
          type = 'number',
          value = ifelse(!is.null(pages_total), pages_total, 0),
          min = 0,
          max = ifelse(!is.null(pages_total), pages_total, 0)
        )
      ),

      # container for pager button groups
      div(
        class = 'page-buttons',

        # prev/next buttons
        span(
          class = 'page-button-group-prev-next btn-group',
          tags$button(
            id = paste(inputId, 'page-prev-button', sep='__'),
            class = 'page-prev-button btn btn-default',
            'Prev'
          ),
          tags$button(
            id = paste(inputId, 'page-next-button', sep='__'),
            class = 'page-next-button btn btn-default',
            'Next'
          )
        ),

        # page number buttons
        # dynamically generated via javascript
        span(
          class = 'page-button-group-numbers btn-group'
        )
      )
    )
  )
}
updatePageruiInput = function(session, inputId, page_current = NULL, pages_total = NULL) {
  message = shiny:::dropNulls(list(
    page_current = shiny:::formatNoSci(page_current),
    pages_total = shiny:::formatNoSci(pages_total)
  ))

  session$sendInputMessage(inputId, message)
}
