

library(shiny)
library(extrafont)

source("R/histogram.R")
source("R/dataset.R")
source("R/selectVar.R")

base_font = "Jost"
heading_font = "Jost"

ui <- fluidPage(
    
    titlePanel("Molecular Biodiversity Greece"),
    
    fluidRow(
        column(3, 
            wellPanel(
                datasetInput("data", is.data.frame),
                selectVarInput("var"),
            )
        ),
        
        column(9, 
            tabsetPanel(
                tabPanel("Table", histogramOutput("hist"))
            )
        )
    )
    
    # sidebarLayout(
    #     
    #     # side bar panel -------------
    #     sidebarPanel(
    #         datasetInput("data", is.data.frame),
    #         selectVarInput("var"),
    #     ),
    #     
    #     # main panel --------------------
    #     mainPanel(
    #         histogramOutput("hist")    
    #     )
    #     
    # ),
    
    # theme ------------------
    # theme = bslib::bs_theme(
    #     base_font = base_font, 
    #     heading_font = heading_font
    # )
)

server <- function(input, output, session) {
    data <- datasetServer("data")
    x <- selectVarServer("var", data)
    histogramServer("hist", x)
}

shinyApp(ui, server)
