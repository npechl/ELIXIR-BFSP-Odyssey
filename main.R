
library(shiny)
library(bslib)
library(data.table)
library(reactable)

source("R/histogram.R")
source("R/dataset.R")
source("R/selectVar.R")



# base_font = "Jost"
# heading_font = "Jost"

ui <- page_sidebar(
    title = "Molecular Biodiversity Greece",
    window_title = "MBioG",
    
    sidebar = sidebar(
        sourceInput("source")
        # fluidPage(
        #     
        # )
    ),
    
    navset_underline(
        
        nav_panel(
            title = "Analysis",
            fluidPage(
                # div(
                #     style = "border: 4px solid #ddd;
                #              padding: 10px; margin-bottom: 20px; 
                #              margin-top: 20px;",
                #     p("Hello world.")
                # ),
                div(
                    id = "data_box",
                    style = "border: 2px solid #ddd; margin-bottom: 20px;
                             padding: 10px; margin-top: 20px;",
                    textOutput("data_rows")
                )
            ),
            
        ),
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
               reactableOutput("table")
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

    df <- datasetServer("dataServer")

    output$table = tableServer("tableServer", df)


    output$data_rows <- renderText({
        paste("Number of Rows: ", nrow(df))
    })

}

shinyApp(ui, server)
