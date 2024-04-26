




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

            ), 
            
            fluidPage(
              br(), 
              card(
                card_header("Taxes tree"),
                full_screen = TRUE, fill = FALSE,
                card_body(
                  #markdown("In this section you can select an organism and visualize a collapsible tree."),
                  echarts4rOutput("tree1")            
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
              leafletOutput("map", height = "55em", width = "auto")
            )
          )
          
        ),

        ## About this app --------------------------
        nav_panel(
            
          title = tags$h6(
              "About this app", 
              style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
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
