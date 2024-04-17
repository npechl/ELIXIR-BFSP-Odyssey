




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
            title = tags$h5("Overview", 
                            style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
            ),  
          
            br(),
            
            layout_column_wrap(
                value_box(
                    title = "Number of observations", 
                    value = textOutput("data_rows"),
                    #theme = value_box_theme(bg = "#272c30", fg = "#d8d8d8")
                    theme = value_box_theme(bg = "#d8d8d8", fg = "#282828")                        
                ),
                
                value_box(
                    title = "Number of tax divisions", 
                    value = textOutput("tax_division"),
                    theme = value_box_theme(bg = "#e5e8ec", fg = "#064467")
                ),
                
                value_box(
                    title = "Number of tags", 
                    value = textOutput("tags"),
                    theme = value_box_theme(bg = "#F3F6FA", fg = "#004164")
                ),
                
                value_box(
                  title = "Number of sientific names", 
                  value = textOutput("names"),
                  theme = value_box_theme(bg = "#F3F6FA", fg = "#004164")
                ), 
                
                value_box(
                  title = "Number of isolation source", 
                  value = textOutput("isolation_source"),
                  theme = value_box_theme(bg = "#F3F6FA", fg = "#004164")
                )
                
            )
            
        ),
        
        
        ## table panel --------------------------------
        
        nav_panel(
          title = tags$h5("Table", 
                          style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
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
                          style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
          ),
          fluidPage(
            br(), 
            p("TODO")
          )
        ),
        
        ## map panel --------------------------
        nav_panel(
          title = tags$h5("About this app", 
                          style = "color: #004164; margin-bottom: 10px; margin-top: 5px;"
          ),
          fluidPage(
            br(), 
            
            h3("Last update", 
               style = "color: #004164"),
            p("This app is updated once every six months."),
            br(),
            
            h3("Contribution", 
               style = "color: #004164"),
            
            p("Your input is invaluable - whether it's suggesting a new chart/analysis or reporting a bug, 
               we welcome and greatly appreciate your feedback!"),
            
            p("Feel free to open a ", 
              tags$a("GitHub issue", 
                     href = "https://github.com/npechl/MBioG/issues",
                     style = "color: #004164"), 
              " or contact us via", 
              tags$a("inab.bioinformatics@lists.certh.gr", 
                     href = "mailto:inab.bioinformatics@lists.certh.gr",
                     style = "color: #004164"), 
              "." ),
            br(),
            
            h3("MIT license",
               style = "color: #004164"),
            
            p("This work, as a whole, is licensed under the",
              tags$a("MIT license", 
                     href = "https://github.com/npechl/MBioG/blob/main/LICENSE",
                     style = "color: #004164"),
            "."),
            
            p(
              "The code contained in this website is simultaneously available under the MIT license; 
              this means that you are free to use it in your own packages, as long as you cite the source."
              ),
            br(),
            
            h3("Authors",
               style = "color: #004164"),
            
            p(tags$a("Nikos Pechlivanis", 
                     href = "https://github.com/npechl",
                     icon("github", lib = "font-awesome"),
                     style = "color: #004164")
              ),
            
            p(tags$a("Natasa Anastasiadou", 
                     href = "https://github.com/NatAnastas",
                     icon("github", lib = "font-awesome"),
                     style = "color: #004164")
            )
          )
        )
    ),
     
    
    
    
    
    # shinny app theme ----------------------------------------
    # theme = bs_theme(
    #     preset = "cerulean",
    #     bg = "#adb4ba",
    #     fg = "#1d2225",
    #     base_font = font_google("Jost")
    # 
    # )

    theme = bs_theme(
      preset = "cerulean",
      bg = "#F3F6FA",
      fg = "#004164",
      base_font = font_google("Jost")

    )

    #base_font = font_google("Jost")
    #bg = c("#F3F6FA", "#D8DFEF") 
    #fg = C("#26456E","#142D4A")

)
