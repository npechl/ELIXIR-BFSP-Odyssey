
rm(list = ls())
gc()


library(shiny)
library(bslib)
library(data.table)
library(reactable)
library(dplyr)

source("R/histogram.R")
source("R/dataset.R")
source("R/selectVar.R")



# base_font = "Jost"
# heading_font = "Jost"

ui <- page_sidebar(
    title = "Molecular Biodiversity Greece",
    window_title = "MBioG",
    
    sidebar = sidebar(
        sourceInput("source"),
        hr(),
        tableOptions("tableFilter"),
        hr(),
        rangeInput("range")
    ),
    
    
    navset_underline(
        
        nav_panel(
            title = "Overview",
            fluidPage(
                div(
                    id = "data_box",
                    style = "border: 2px solid #ddd; 
                             margin-bottom: 20px;
                             padding: 10px; 
                             margin-top: 20px;",
                    textOutput("data_rows")
                )
            ),
            
        ),
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
                reactableOutput("table"),
                verbatimTextOutput("selected")
            )
            
        ),
        
        nav_panel(title = "Map",
                  p("TODO"))
    ),
    
    theme = bs_theme(
        preset = "cosmo",
        base_font = font_google("Jost")
    )
    
)


server <- function(input, output, session) {
    
    
    #df1 <- datasetServer("dataServer")
    
    
    out = fread("inst/extdata/data.tsv")
    
    sorted <- out[order(out$first_public), ]
    
    
    
    
    df1 <- reactive({
        
        months_of_interest <- input$range
        
        
        filtered_df <- sorted |>
            filter(first_public >= months_of_interest)
        
        return(filtered_df)
        
    })
    
    
    
    
    # output$table <- tableServer("tableServer", df1())
    # 
    # output$data_rows <- textServer("textServer", df1)
    
    output$table <- renderReactable ({
        reactable(
            df1(),
            groupBy = "tax_division",
            bordered = TRUE,
            filterable = as.logical(input$tableFilter),
            #minRows = 10,
            #paginationType = "jump",
            #showPageSizeOptions = TRUE,
            #paginationType = "simple",
        )
        
    })
    
    
    
    output$data_rows <- renderText({
        
        paste0("Number of Rows: ",  nrow(df1()))
        
    })
    
    # filtered_rows <- reactive({
    #     nrow(df1())
    # })
    # 
    # 
    # 
    
    # 
    
}


shinyApp(ui, server)
