

library(shiny)
library(bslib)
library(data.table)

source("R/histogram.R")
source("R/dataset.R")
source("R/selectVar.R")



# base_font = "Jost"
# heading_font = "Jost"

ui <- page_sidebar(
    
    # titlePanel("Molecular Biodiversity Greece"),
    title = "Molecular Biodiversity Greece",
    window_title = "MBioG",
    
    sidebar = sidebar(
        datasetInput("data", is.data.frame)
        # selectVarInput("var")
    ),
    
    navset_underline(
        nav_panel(title = "Table")
        #nav_panel(title = "Table", histogramOutput("hist"))
    ),
    
    theme = bs_theme(
        preset = "cosmo",
        base_font = font_google("Jost")
    ),
    
    fluidPage(
        tableOutput("static")
    ), 
    
    # fluidRow(
    #     column(3, 
    #         
    #     ),
    #     
    #     column(9, 
    #         
    #     )
    # ),
    
    # thematic::thematic_on(
    #     bg = "auto", 
    #     fg = "auto", 
    #     accent = "auto", 
    #     font = "auto"
    # ),
    
)

server <- function(input, output, session) {
    data <- datasetServer("data")
    
    df = fread("../MBioG/inst_ext_data/MBioG.csv", sep = ",")
    
    output$static <- renderTable(head(df))
    # x <- selectVarServer("var", data)
    # histogramServer("hist", x)
}

shinyApp(ui, server)
