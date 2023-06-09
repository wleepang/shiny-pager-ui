#' Create a pager-ui Input control
#'
#' @param inputId The \code{input} slot that will be used to access the value
#' @param page_current The currently selected page
#' @param total_pages The total number of pages available
#'
#' @seealso
#' \link{updatePageruiInput}
#'
#' @import shiny
#' @import htmltools
#'
#' @export
pageruiInput = function(inputId, page_current = NULL, pages_total = NULL) {
  # construct the pager-ui framework
  tagList(
    # root pager-ui node
    div(
      id = inputId,
      class = 'pager-ui',

      # container for hidden numeric fields
      div(
        class = 'invisible',

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
        ),

        # javascript assets
        htmlDependency(
          name = paste(packageName(), 'assets', sep = '-'),
          version = packageVersion(packageName()),
          package = packageName(),
          src = 'assets',
          script = c(
            'js/input_binding_pager-ui.js',
            'js/underscore-min.js',
            'js/underscore-min.map'
          )
        )

        ##
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
#'
#' @import shiny
#' @export
updatePageruiInput = function(session, inputId, page_current = NULL, pages_total = NULL) {
  message = shiny:::dropNulls(list(
    page_current = shiny:::formatNoSci(page_current),
    pages_total = shiny:::formatNoSci(pages_total)
  ))

  session$sendInputMessage(inputId, message)
}

#' Runs example application for shinyPagerUI
#'
#' @importFrom shiny runApp
#' @export
runExamplePagerUI = function() {
  app_dir = system.file('example_app', package = packageName())

  if (is.na(app_dir) || app_dir == '') {
    stop("Could not find example. Try re-installing package.", call. = FALSE)
  }

  runApp(app_dir, display.mode = 'normal')
}
