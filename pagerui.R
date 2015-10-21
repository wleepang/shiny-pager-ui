#' Create a pager-ui Input control
#'
#' @param inputId The \code{input} slot that will be used to access the value
#' @param page_current The currently selected page
#' @param total_pages The total number of pages available
#'
#' @seealso
#' \link{updatePageruiInput}
pageruiInput = function(inputId, page_current = NULL, pages_total = NULL) {
  # construct the pager-ui framework
  tagList(
    singleton(
      tags$head(
        tags$script(src = 'js/underscore-min.js'),
        tags$script(src = 'js/input_binding_pager-ui.js')
      )
    ),

    # root pager-ui node
    div(
      id = inputId,
      class = 'pager-ui',

      # container for hidden numeric fields
      div(
        class = 'hidden',

        # numeric input to store current page
        tags$input(
          id = paste(inputId, 'page_current', sep='__'),
          class = 'page-current',
          type = 'number',
          value = ifelse(!is.null(page_current), page_current, 1),
          min = 1,
          max = ifelse(!is.null(pages_total), pages_total, 1)
        ),

        # numeric input to store total pages
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

#' Change the value of a pager-ui input on the client
#'
#' @param session The \code{session} object passed to function given to \code{shinyServer}
#' @param inputId The id of the input object
#' @param page_current Current page value
#' @param pages_total Total pages value
#'
#' @seealso
#' \link{pageruiInput}
updatePageruiInput = function(session, inputId, page_current = NULL, pages_total = NULL) {
  message = shiny:::dropNulls(list(
    page_current = shiny:::formatNoSci(page_current),
    pages_total = shiny:::formatNoSci(pages_total)
  ))

  session$sendInputMessage(inputId, message)
}
