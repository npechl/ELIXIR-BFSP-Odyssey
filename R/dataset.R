

library(shiny)
library(data.table)
library(stringr)
library(lubridate)
library(dplyr)

sourceInput <- function(id) {
    
    radioButtons(
        NS(id, "sourceInput"), 
        "Input data source",
        choices = c("EBI")
    )
    
}

groupbyOptions <- function(id) {

    checkboxGroupInput(
        "group_by",
        "Group by",
        choices = c("Tax_division" = "tax_division", 
                    "Sientific_name" = "scientific_name", 
                    "Tag" = "tag"),
        selected = NULL
    )

}

tableOptions <- function(id) {
    
    checkboxInput(
        "tableFilter",
        "Show filter",
        FALSE)
    
}

rangeInput <- function(id) {
    
    dateRangeInput(
        "range",
        "Dates of interest:",
        start = Sys.Date() - months(6),
        end = Sys.Date()        
    )
    
}



#' #' @export
#' datasetServer <- function(id) {
#'     moduleServer(id, function(input, output, session) {
#' 
#'         # reactive(get(input$dataset, "package:datasets"))
#'         out = fread("inst/extdata/data.tsv")
#' 
#'         sorted <- out[order(out$first_public), ]
#'         
#' 
#'         # months_of_interest <- input$range
#'         # #six_months_ago <- Sys.Date() - months(6)
#'         # 
#'         # filtered_df <- sorted |>
#'         #             filter(first_public >= months_of_interest)
#'         # 
#'         # 
#'         # 
#'         # 
#'         # return(filtered_df)
#' 
#' 
#' 
#'         
#'         # mask = out |>
#'         #     nrow() |>
#'         #     seq_len() |>
#'         #     sample(100)
#' 
#' 
#'         #return(out[mask])
#' 
#' 
#'     })
#' }



# tableServer <- function(id, df) {
#     moduleServer(id, function(input, output, session) {
# 
#         renderReactable({
#             reactable(
#                     df,
#                     groupBy = "tax_division",
#                     minRows = 10,
#                     paginationType = "jump",
#                     bordered = TRUE,
#                     showPageSizeOptions = TRUE,
#                     filterable = as.logical(input$tableFilter)
#                 )
#         })
#     })
# }








# textServer <- function(id, df) {
#      moduleServer(id, function(input, output, session) {
# 
#          renderText({
#              paste("Number of Rows: ",  nrow(df))
#          })
#          
#     })
# }



# tableServer <- function(id, df) {
#     moduleServer(id, function(input, output, session) {
#         
#         renderTable(df[1:100])
#         
#     })
# }


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
