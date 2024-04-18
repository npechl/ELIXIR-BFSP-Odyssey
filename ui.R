




ui <- page_sidebar(
  
    title = tags$html(
      h3(
        "Exploring Molecular Biodiversity in Greece",
         style = "color: #F3F6FA; margin-bottom: 5px; margin-top: 5px"
        ),

      a(
        href = "https://github.com/npechl/odyssey",
        icon("github", lib = "font-awesome"),
        target = "_blank",
        style = "color: #F3F6FA; margin-bottom: 5px; margin-top: 5px; 
                 font-size: 1.5em;"   
      )
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
            title = tags$h5("Overview", 
                            style = "color: #004164; margin-bottom: 10px;
                                     margin-top: 5px;"
            ),  
          
            br(),
            
            layout_column_wrap(
                value_box(
                    title = "Number of observations", 
                    value = textOutput("data_rows"),
                    theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")                        
                ),
                
                value_box(
                    title = "Number of tax divisions", 
                    value = textOutput("tax_division"),
                    theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")
                ),
                
                # value_box(
                #     title = "Number of tags", 
                #     value = textOutput("tags"),
                #     theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")
                # ),
                
                value_box(
                  title = "Number of sientific names", 
                  value = textOutput("names"),
                  theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")
                ), 
                
                value_box(
                  title = "Number of isolation source", 
                  value = textOutput("isolation_source"),
                  theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")
                )
                
            )
            
        ),
        
        
        ## table panel --------------------------------
        
        nav_panel(
          title = tags$h5("Table", 
                          style = "color: #004164; margin-bottom: 10px; 
                                   margin-top: 5px;"
          ),      
            fluidPage(
                br(),
                card(full_screen = TRUE, fill = FALSE, reactableOutput("table"))
            ), 
            
            downloadButton("download", "Download as CSV")
            
        ),
        
        ## map panel --------------------------
        nav_panel(
          title = tags$h5("Map", 
                          style = "color: #004164; margin-bottom: 10px; 
                                   margin-top: 5px;"
          ),
          fluidPage(
            br(), 
            p("TODO")
          )
        ),
        
        ## About this app --------------------------
        nav_panel(
          title = tags$h5("About this app", 
                          style = "color: #004164; margin-bottom: 10px;
                                   margin-top: 5px;"
          ),
          fluidPage(
            br(),
            uiOutput("about")
            
          )
        )
    ),
     

    # shinny app theme ----------------------------------------
    theme = bs_theme(
      preset = "cerulean",
      bg = "#F3F6FA",
      fg = "#004164",
      base_font = font_google("Jost")

    )


)
