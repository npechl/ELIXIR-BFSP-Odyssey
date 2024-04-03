




ui <- page_sidebar(
    title = "Exploring Molecular Biodiversity in Greece",
    window_title = "Odyssey",
    
    
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
            
            br(),
            
            layout_column_wrap(
                value_box(
                    title = "Number of Observations", 
                    value = textOutput("data_rows"),
                    theme = value_box_theme(bg = "#d8d8d8", fg = "#282828")
                ),
                
                value_box(
                    title = "Number of Tax divisions", 
                    value = "blaavladfojis",
                    theme = value_box_theme(bg = "#d8d8d8", fg = "#282828")
                ),
                
                value_box(
                    title = "Number of tags", 
                    value = "jfosdjfodjosdij",
                    theme = value_box_theme(bg = "#d8d8d8", fg = "#282828")
                )
            )
            
        ),
        
        ## table panel --------------------------------
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
                br(),
                card(full_screen = TRUE, fill = FALSE, reactableOutput("table"))
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
        preset = "cosmo",
        base_font = font_google("Jost")
    )
    
)