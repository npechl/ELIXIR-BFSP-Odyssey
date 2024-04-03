



sourceInput <- function(id) {
    
    radioButtons(NS(id, "source_input"), "Input data source",choices = c("EBI"))
    
}

tableOptions <- function(id) {
    
    
    tagList(
        
        checkboxInput(NS(id, "table_filter"), "Show filter", FALSE), hr(),
        
        checkboxGroupInput(
            NS(id, "group_by"), "Group by", selected = NULL,
            choices = c(
                "Tax_division"   = "tax_division", 
                "Sientific_name" = "scientific_name",
                "Tag"            = "tag"
            )
        ), hr(),
        
        dateRangeInput(
            NS(id, "range"), "Dates of interest:",
            start = Sys.Date() - months(6), end = Sys.Date(),
            max =  Sys.Date()
        )
        
        
    )
    
}

datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {

        out = fread("inst/extdata/data_ebi.tsv")

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
        
        
        renderReactable({
            reactable(
                df(),
                groupBy = input$group_by,
                filterable = input$table_filter |> as.logical(),
                
                minRows = 15, paginationType = "jump",
                bordered = FALSE, showPageSizeOptions = TRUE
            )
        })
        
    })
}

textServer1 <- function(id, df) {
     moduleServer(id, function(input, output, session) {

         renderText({  nrow(df()) |> scales::comma() })

    })
}

textServer2 <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        renderText({ paste("Table statistics: ") })
        
    })
}



