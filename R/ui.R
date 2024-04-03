




ui <- page_sidebar(
    title = "Molecular Biodiversity Greece",
    window_title = "MBG",
    
    
    # sidebar options ------------------
    sidebar = sidebar(
        sourceInput("source"),
        hr(),
        
        tableOptions("table1"),
        hr()
    ),
    
    # navigation -------------------
    navset_underline(
        
        ## overview panel --------------------------
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
        
        ## table panel --------------------------------
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
                br(),
                reactableOutput("table"),
            )
            
        ),
        
        ## map panel --------------------------
        nav_panel(
            title = "Map",
            fluidPage(
                br(), p("TODO")
            )
        )
    ),
    
    # shinny app theme ----------------------------------------
    theme = bs_theme(
        preset = "simplex",
        base_font = font_google("Jost")
    )
    
)