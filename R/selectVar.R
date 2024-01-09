

library(shiny)

find_vars <- function(data, filter) {
    names(data)[vapply(data, filter, logical(1))]
}

#' @export
selectVarInput <- function(id) {
    selectInput(NS(id, "var"), "Variable", choices = NULL) 
}

#' @export
selectVarServer <- function(id, data, filter = is.numeric) {
    moduleServer(id, function(input, output, session) {
        
        observeEvent(data(), {
            updateSelectInput(
                session, "var", choices = find_vars(data(), filter)
            )
        })
        
        reactive(data()[[input$var]])
    })
}

# selectDataVarUI <- function(id) {
#     tagList(
#         datasetInput(NS(id, "data"), filter = is.data.frame),
#         selectVarInput(NS(id, "var"))
#     )
# }





