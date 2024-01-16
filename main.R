

library(shiny)
library(bslib)
# library(extrafont)

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
        datasetInput("data", is.data.frame),
        selectVarInput("var")
    ),
    
    navset_underline(
        nav_panel(title = "Table", histogramOutput("hist")),
        nav_panel(title = "Map", p("Third tab content"))
    ),
    
    theme = bs_theme(
        preset = "cosmo",
        base_font = font_google("Jost")
    )
    
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
    x <- selectVarServer("var", data)
    histogramServer("hist", x)
}

shinyApp(ui, server)
