
library(shiny)
library(bslib)
library(data.table)

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
    ),
    
    navset_underline(
        nav_panel(
            title = "First page"
        ),
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
               reactableOutput("table")
            )
            
        ),
        
        nav_panel(title = "Map", p("TODO"))
    ),
    
    theme = bs_theme(
        preset = "cosmo",
        base_font = font_google("Jost")
    )
    
)

server <- function(input, output, session) {
    
    df <- datasetServer("dataServer")
    
    output$table = tableServer("tableServer", df) 
    
}

shinyApp(ui, server)
