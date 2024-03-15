
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
    window_title = "MBG",
    
    sidebar = sidebar(
        sourceInput("source"),
        hr(),
        tableOptions("table1"),
        hr()
    ),
    
    
    navset_underline(
        
        nav_panel(
            title = "Overview",
            fluidPage(

                div(
                    id = "data_box",
                    style = "border: 3px solid #ddd;
                             margin-bottom: 20px;
                             padding: 10px;
                             margin-top: 20px;",
                    textOutput("data_rows")
                ),
                div(
                    id = "statistics",
                    style = "border: 3px solid #ddd;
                             margin-bottom: 20px;
                             padding: 10px;
                             margin-top: 20px;",
                    textOutput("table_statistics")

                )
            ),
            
        ),
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
                reactableOutput("table"),
            )
            
        ),
        
        nav_panel(
            title = "Map",
            p("TODO")
        )
    ),
    
    theme = bs_theme(
        preset = "cosmo",
        base_font = font_google("Jost")
    )
    
)


server <- function(input, output, session) {
    
    df_raw <- datasetServer("table1")
     
    df1 <- filterServer("table1", df_raw)
    
    output$table <- tableServer("table1", df1())
    
    output$data_rows <- textServer1("table1", df1)

    output$table_statistics <- textServer2("table1", df1)

}


shinyApp(ui, server)
