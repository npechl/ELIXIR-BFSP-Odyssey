

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


lexicon <- function(string) {
    
    string |>
        str_replace_all("Rethymnon|Rethymno|Rethimno", "Rethimnon")
    
    
}

# correct_coordinates <- function(string) {
#     
#     coordinates_df = string |> 
#         str_remove_all("[A-Z]") |>
#         str_squish() |>
#         str_split("\\ ", simplify = TRUE) |>
#         as.data.table()
#     
#     colnames(coordinates_df) = c("long", "lat")
#     
#     return(coordinates_df)
#     
# }

# correct_location <- function(string) {
#     
#     dict = string |> 
#         str_split("\\,|\\ |-|[0-9]|\\(|\\)|\\'|\\.|&|>|<|\\/|=") |> 
#         unlist() |>
#         unique() |>
#         str_squish() |>
#         sort()
#     
#     out = data.table(
#         "loc1" = string |> str_split_i("\\,", 1) |> str_squish(),
#         "loc2" = string |> str_split_i("\\,", 2) |> str_squish()
#     )
#     
#     out = out |> unique()
#     
# }

retrieve_ebi_data <- function(string) {
    
    if( !RCurl::url.exists(string) ) stop(c("url ", string, " not accessible!"))
    
    df = string |> fread(verbose = FALSE)
    
    # correct scientific name
    df$scientific_name = df$scientific_name |> str_squish() |> str_to_title()
    
    df$country = df$country |>
        str_replace_all("-|\\[|\\]|\\(|\\)", " ") |>
        str_squish()
    
    
    df$region = df$country |>
        str_split_i("\\:", 2) |>
        str_squish() |>
        str_to_title()
    
    df$country = df$country |> str_split_i("\\:", 1)
    df$country = ifelse(df$country == "Greece Greece", "Greece", df$country)
    
    df = df[which(country == "Greece")]
    
    # df$subregion = df$region |>
    #     str_split("\\,") |>
    #     lapply(function(a) ifelse(length(a) > 1, a[2], a[1]) ) |>
    #     lapply(str_squish) |>
    #     unlist()
    # 
    # df$region = df$region |> str_split_i("\\,", 1)
    
    
    df$lat = df$location |>
        str_split_i("N", 1) |>
        str_squish() |>
        as.numeric()
    
    df$lon = df$location |>
        str_split_i("N", 2) |>
        str_remove_all("E") |>
        str_squish() |>
        as.numeric()
    
    # part 2 --------------------------
    
    a = df[which( !is.na(lat) & !is.na(lon) )]
    b = df[which( is.na(lat) | is.na(lon) )]
    
    # index = match(b$subregion, greece_cities$name)
    # 
    # b$lat = greece_cities[index]$lat
    # b$lon = greece_cities[index]$long
    # 
    # 
    # a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
    # b = b[which(is.na(lat) | is.na(lon))]
    # 
    # 
    # index = match(b$region, greece_cities$name)
    # 
    # b$lat = greece_cities[index]$lat
    # b$lon = greece_cities[index]$long
    # 
    # 
    # a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
    # b = b[which(is.na(lat) | is.na(lon))]
    # 
    # 
    # for(i in seq_along(greece_cities$name)) {
    #     
    #     index = b$subregion |>
    #         str_detect(greece_cities[i]$name) |>
    #         which()
    #     
    #     b[index]$lat = greece_cities[i]$lat
    #     b[index]$lon = greece_cities[i]$long
    #     
    # }
    # 
    # a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
    # b = b[which(is.na(lat) | is.na(lon))]
    
    for(i in seq_along(greece_cities$name)) {
        
        index = b$region |>
            str_detect(greece_cities[i]$name) |>
            which()
        
        b[index]$lat = greece_cities[i]$lat
        b[index]$lon = greece_cities[i]$long
        
    }
    
    # a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
    # b = b[which(is.na(lat) | is.na(lon))]
    # 
    # b[which(str_detect(region, "Crete"))]$lat = 35.05
    # b[which(str_detect(region, "Crete"))]$lon = 25.41
    # 
    # a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
    # b = b[which(is.na(lat) | is.na(lon))]
    
    # tmp = b$region |> table() |> as.data.frame() |> setDT()
    # 
    # tmp = tmp[order(-Freq)]
    # 
    # rm(tmp, ann, i, index)
    
    df = rbind(a, b)
    
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
