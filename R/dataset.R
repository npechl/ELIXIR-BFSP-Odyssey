

library(shiny)
library(data.table)
library(stringr)

#' @export
datasetInput <- function(id, filter = NULL) {
    
    names <- ls("package:datasets")
    
    if (!is.null(filter)) {
        data <- lapply(names, get, "package:datasets")
        names <- names[vapply(data, filter, logical(1))]
    }
    
    selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

#' @export
datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        reactive(get(input$dataset, "package:datasets"))
    })
}

correct_coordinates <- function(string) {
    
    coordinates_df = string |> 
        str_remove_all("[A-Z]") |>
        str_squish() |>
        str_split("\\ ", simplify = TRUE) |>
        as.data.table()
    
    colnames(coordinates_df) = c("long", "lat")
    
    return(coordinates_df)
    
}

retrieve_ebi_data <- function(string) {
    
    if( !RCurl::url.exists(string) ) stop(c("url ", string, " not accessible!"))
    
    df = string |> fread(verbose = FALSE)
    
    # correct scientific name
    df$scientific_name = df$scientific_name |> str_to_title()
    
    # correct location coordinates
    df = cbind(df, correct_coordinates(df$location))
    
    # update location coordinates
    
    
}


# datasetApp <- function(filter = NULL) {
#     ui <- fluidPage(
#         datasetInput("dataset", filter = filter),
#         tableOutput("data")
#     )
#     server <- function(input, output, session) {
#         data <- datasetServer("dataset")
#         output$data <- renderTable(head(data()))
#     }
#     shinyApp(ui, server)
# }
