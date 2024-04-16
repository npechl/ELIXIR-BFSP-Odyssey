




ui <- page_sidebar(
    title = tags$html(
      tags$h3(
              "Exploring Molecular Biodiversity in Greece",
              style = "color: #F3F6FA; margin-bottom: 5px; margin-top: 5px"
              ),
      tags$a(
             href = "https://github.com/npechl/odyssey",
             icon("github", lib = "font-awesome"),
             target = "_blank",
             style = "color: #F3F6FA; margin-bottom: 5px; margin-top: 5px; font-size: 1.5em;"
      ),
    ),
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
                    value = textOutput("tax_division"),
                    theme = value_box_theme(bg = "#f2f2f2", fg = "#064467")
                ),
                
                value_box(
                    title = "Number of tags", 
                    value = textOutput("tags"),
                    theme = value_box_theme(bg = "#F3F6FA", fg = "#003355")
                )
            )
            
        ),
        
        ## table panel --------------------------------
        
        nav_panel(
            title = "Table",  
            
            fluidPage(
                br(),
                card(full_screen = TRUE, fill = FALSE, reactableOutput("table"))
            ), 
            
            downloadButton("download", "Download table")
            
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
        preset = "cerulean",
        bg = "#F3F6FA",
        fg = "#003355",
        #base_font = font_google("Jost")
        #bg = c("#F3F6FA", "#D8DFEF") 
        #fg = C("#26456E","#142D4A")
    )

)