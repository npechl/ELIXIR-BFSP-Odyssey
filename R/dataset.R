

library(shiny)
library(data.table)
library(stringr)

sourceInput <- function(id) {
    
    radioButtons(
        NS(id, "sourceInput"), 
        "Input data source",
        choices = c("EBI")
    )
    
}

#' @export
datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {
        
        # reactive(get(input$dataset, "package:datasets"))
        out = fread("inst/extdata/data.tsv")
        
        mask = out |>
            nrow() |>
            seq_len() |>
            sample(100)
        
        return(out[mask])
        
    })
}

tableServer <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        # df <- reactive()
        output$table <- renderReactable({
            reactable(df, filterable = TRUE, minRows = 10)
        })
    })
}

# tableServer <- function(id, df) {
#     moduleServer(id, function(input, output, session) {
#         
#         renderTable(df[1:100])
#         
#     })
# }


lexicon <- function(string) {
    
    string |>
        str_replace_all("Rethymnon|Rethymno|Rethimno", "Rethimnon") |>
        str_replace_all("Carpathos")
    
    
}


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
    
    df$lat = df$location |>
        str_split_i("N", 1) |>
        str_squish() |>
        as.numeric()
    
    df$lon = df$location |>
        str_split_i("N", 2) |>
        str_remove_all("E") |>
        str_squish() |>
        as.numeric()
    
    df$region = df$region |> lexicon()
    
    # part 2 --------------------------
    
    a = df[which( !is.na(lat) & !is.na(lon) )]
    b = df[which( is.na(lat) | is.na(lon) )]
    
    for(i in seq_along(greece_cities$name)) {
        
        index = b$region |>
            str_detect(greece_cities[i]$name) |>
            which()
        
        b[index]$lat = greece_cities[i]$lat
        b[index]$lon = greece_cities[i]$long
        
    }
    
    a = rbind(a, b[which( !is.na(lat) & !is.na(lon) )])
    b = b[which(is.na(lat) | is.na(lon))]
    
    df = rbind(a, b)
    
}


