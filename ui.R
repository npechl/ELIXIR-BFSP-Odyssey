




ui <- page_sidebar(
  
    title = tagList(
      h3(
        "Exploring Molecular Biodiversity in Greece",
         style = "color: #F3F6FA; margin-bottom: 1px; margin-top: 1px; 
                  white-space: nowrap;"
        ),
      div(
        style = "position: absolute; top: 0; right: 0; display: flex; 
                 align-items: center; height: 100%;",
        a(
          href = "https://github.com/npechl/odyssey",
          icon("github", lib = "font-awesome"),
          target = "_blank",
          style = "color: #F3F6FA; margin-top: 5px;
               font-size: 1.5em; margin-left: 0; padding-right: 15px;"
        ),
        a(
          href = "https://github.com/npechl/odyssey/issues",
          icon("circle-dot", lib = "font-awesome"),
          target = "_blank",
          style = "color: #F3F6FA; margin-top: 5px;
               font-size: 1.3em; margin-right: 5px"
        ),
        # a(
        #   href = "https://github.com/npechl/odyssey/blob/main/LICENSE",
        #   icon("scale-balanced", lib = "font-awesome"),
        #   target = "_blank",
        #   style = "color: #F3F6FA; margin-top: 5px;
        #        font-size: 1.2em; margin-right: 10px"
        # )
      )
    ),
    
    window_title = "Odyssey",
    

    # sidebar options ------------------
    sidebar = sidebar(
        sourceInput("source"),
        hr(),
        
        tableOptions("table1"),
        hr(),
        
        fluidPage(
          style = "position: absolute; bottom: 15px; left: 0; right: 0;",
          h5(
            "Authors",
            style = "color: #004164;"
          ),
          p(
            a(
              href = "https://github.com/npechl",
              style = "color: #004164;",
              "Nikos Pechlivanis ", 
              icon("github", lib = "font-awesome")
            )
          ),
          p(
            a(
              href = "https://github.com/NatAnastas",
              style = "color: #004164;",
              "Natasa Anastasiadou ", 
              icon("github", lib = "font-awesome")
            )
          )
        )
        
    ),
    
    # navigation -------------------
    navset_underline(

        ## overview panel --------------------------
        nav_panel(
            title = tags$h6(
                "Overview", 
                style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
            ),  
          
            br(),
            
            layout_column_wrap(
                value_box(
                    title = "Number of observations", 
                    value = textOutput("data_rows"),
                    theme = value_box_theme(bg = "#e5e8ec", fg = "#064467"),
                    showcase = echarts4rOutput("plot1"),
                    full_screen = TRUE
                ),
                
                value_box(
                    title = "Number of tax divisions", 
                    value = textOutput("tax_division"),
                    p("Tax with maximum number: ", ),
                    p("Tax with minimum number: ",  ),
                    theme = value_box_theme(bg = "#e5e8ec", fg = "#064467"),
                    showcase = echarts4rOutput("plot2"),
                    full_screen = TRUE
                ),

                value_box(
                  title = "Number of sientific names", 
                  value = textOutput("names"),
                  theme = value_box_theme(bg = "#e5e8ec", fg = "#064467"),
                  showcase = echarts4rOutput("plot3"),
                  full_screen = TRUE
                ), 
                
                value_box(
                  title = "Number of isolation source", 
                  value = textOutput("isolation_source"),
                  theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")
                )

            ), 
            
            fluidPage(
              br(), 
              card(
                card_header("Taxes tree"),
                full_screen = TRUE, fill = FALSE,
                card_body(
                  echarts4rOutput("tree1", height = "35em", width = "auto")            
                ),
                
              )
            )
        ),
        
        
        ## table panel --------------------------------
        
        nav_panel(
          title = tags$h6("Table", 
                          style = "color: #004164; margin-bottom: 10px; 
                                   margin-top: 5px;"
            ),      
            fluidPage(
                br(),
                card(full_screen = TRUE, fill = TRUE, reactableOutput("table"))
            ), 
            
            downloadButton("download", "Download as CSV")
            
        ),
        
        ## map panel --------------------------
        
        nav_panel(
            
          title = tags$h6(
              "Map", 
              style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
              
          ),
          
          fluidPage(
            br(), 
            card(
              full_screen = TRUE, fill = FALSE, 
              leafletOutput("map", height = "67em", width = "auto")
            )
          )
          
        ),

        ## About this app --------------------------
        # nav_panel(
        #     
        #   title = tags$h6(
        #       "About this app", 
        #       style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
        #   ),
        #   
        #   fluidPage(
        #     br(),
        #     uiOutput("about")
        #   )
        #   
        # )
        
    ),
     

    # shinny app theme ----------------------------------------
    theme = bs_theme(
      preset = "cerulean",
      bg = "#F3F6FA",
      fg = "#004164",
      base_font = font_google("Jost")

    )


)
