

library(shiny)
library(data.table)
library(stringr)
library(lubridate)
library(dplyr)


sourceInput <- function(id) {
    
    radioButtons(NS(id, "source_input"), "Input data source",choices = c("EBI"))
    
}

tableOptions <- function(id) {
    tagList(
        checkboxInput(NS(id, "table_filter"), "Show filter",FALSE),
        hr(),
        checkboxGroupInput(NS(id, "group_by"), "Group by", selected = NULL,
                           choices = c("Tax_division" = "tax_division", 
                           "Sientific_name" = "scientific_name","Tag" = "tag")),
        hr(),
        dateRangeInput(NS(id, "range"), "Dates of interest:",
                       start = Sys.Date() - months(6), end = Sys.Date(),
                       max =  Sys.Date())
        
    )
}

datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {

        out = fread("inst/extdata/data.tsv")

    })
}

filterServer <- function(id, df) {
    moduleServer(id, function(input, output, session) {

     filtered <- reactive({
         df[first_public >= input$range[1] & first_public <= input$range[2]]
       })
    })
}

tableServer <- function(id, df) {
    moduleServer(id, function(input, output, session) {

        filtered_df <- reactive({
            df[first_public >= input$range[1] & first_public <= input$range[2]
            ]
        })


        renderReactable({
            reactable(
                    filtered_df(),
                    groupBy = input$group_by,
                    minRows = 10,
                    paginationType = "jump",
                    bordered = TRUE,
                    showPageSizeOptions = TRUE,
                    filterable = as.logical(input$table_filter)
                )

        })
    })
}

textServer1 <- function(id, df) {
     moduleServer(id, function(input, output, session) {

         renderText({ paste("Number of Rows: ",  nrow(df())) })

    })
}

textServer2 <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        renderText({ paste("Table statistics: ") })
        
    })
}



# lexicon <- function(string) {
#     
#     string |>
#         str_replace_all("Rethymnon|Rethymno|Rethimno", "Rethimnon") |>
#         str_replace_all("Carpathos")
#     
#     
# }
# 
# 
# retrieve_ebi_data <- function(string) {
#     
#     if( !RCurl::url.exists(string) ) stop(c("url ", string, " not accessible!"))
#     
#     df = string |> fread(verbose = FALSE)
#     
#     # correct scientific name
#     df$scientific_name = df$scientific_name |> str_squish() |> str_to_title()
#     
#     df$country = df$country |>
#         str_replace_all("-|\\[|\\]|\\(|\\)", " ") |>
#         str_squish()
#     
#     
#     df$region = df$country |>
#         str_split_i("\\:", 2) |>
#         str_squish() |>
#         str_to_title()
#     
#     df$country = df$country |> str_split_i("\\:", 1)
#     df$country = ifelse(df$country == "Greece Greece", "Greece", df$country)
#     
#     df = df[which(country == "Greece")]
#     
#     df$lat = df$location |>
#         str_split_i("N", 1) |>
#         str_squish() |>
#         as.numeric()
#     
#     df$lon = df$location |>
#         str_split_i("N", 2) |>
#         str_remove_all("E") |>
#         str_squish() |>
#         as.numeric()
#     
#     df$region = df$region |> lexicon()
#     
#     # part 2 --------------------------
#     
#     a = df[which( !is.na(lat) & !is.na(lon) )]
#     b = df[which( is.na(lat) | is.na(lon) )]
#     
#     for(i in seq_along(greece_cities$name)) {
#         
#         index = b$region |>
#             str_detect(greece_cities[i]$name) |>
#             which()
#         
#         b[index]$lat = greece_cities[i]$lat
#         b[index]$lon = greece_cities[i]$long
#         
#     }
#     
#     a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
#     b = b[which(is.na(lat) | is.na(lon))]
#     
#     df = rbind(a, b)
#     
# }
# 
# 
