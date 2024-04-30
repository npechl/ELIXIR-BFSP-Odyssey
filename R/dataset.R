
sourceInput <- function(id) {
    
  radioButtons(NS(id, "source_input"), "Input data source", choices = c("ENA"))
    
}

tableOptions <- function(id) {
    
    
    tagList(
        
        checkboxInput(NS(id, "table_filter"), "Show filter", FALSE), 
        hr(),
        
        checkboxGroupInput(
            NS(id, "group_by"), "Group by", selected = NULL,
            choices = c(
                "Tax_division"   = "tax_division2", 
                "Sientific_name" = "scientific_name",
                "Tag1"            = "tag1",
                "Tag2"            = "tag2",
                "Tag3"            = "tag3"
            )
        ), 
        hr(),
        
        dateRangeInput(
            NS(id, "range"), "Dates of interest:",
            start = Sys.Date() - months(6), end = Sys.Date(),
            max =  Sys.Date()
        )
        
        
    )
    
}

datasetServer <- function(id) {
    moduleServer(id, function(input, output, session) {

        out = fread("inst/extdata/data_ena_clean.tsv") 
        
        out = out[order(-first_public)]
        
        return(out)
        
        # out = out |>
        #   dplyr::select(-altitude, -host_tax_id, -tax_division, -tax_id, 
        #                 -lat, -long, -tag, -location)
        

    })
}

filterServer <- function(id, df) {
    
    moduleServer(id, function(input, output, session) {
        
        filtered <- reactive({
            
            df[first_public >= input$range[1] & first_public <= input$range[2]]
            
        })
        
    })
    
}

tableServer <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        
        renderReactable({
            
            reactable(
                df()[, c(
                    "accession", "first_public", "country", "region", "altitude",
                    "host", "host_tax_id", "isolation_source", 
                    "scientific_name", "tax_id", "topology", "tax_division2",  
                    "tag1", "tag2", "tag3", "keywords"                        
                ), with = FALSE],
                columns = list(
                  accession = colDef(
                    cell = function(value) {
                    # Render as a link
                    url <- sprintf("https://www.ebi.ac.uk/ena/browser/view/%s", value)
                    htmltools::tags$a(href = url, target = "_blank", as.character(value))
                  })),
                groupBy = input$group_by,
                filterable = input$table_filter |> as.logical(),
                theme = reactableTheme( backgroundColor  = "#F3F6FA" ),
                paginationType = "jump",
                defaultPageSize = 15, 
                showPageSizeOptions = TRUE,
                pageSizeOptions = c(15, 25, 50, 100),
                selection = "multiple",
                onClick = "select",
                rowStyle = list(cursor = "pointer")
            )
        })
        
    })
}

textServer1 <- function(id, df) {
    
     moduleServer(id, function(input, output, session) {

         renderText({  df() |> nrow() |> scales::comma() })
       
    })
    
}

textServer2 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderText({ df()$tax_division2 |> unique() |> length() })
    
  })
}

textServer3 <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        renderText({ df()$scientific_name |> unique() |> length() })
        
    })
}

textServer4 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderText({ df()$isolation_source |> unique() |> length() })
    
  })
}

mapServer <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        renderLeaflet({
            
            df_map <- df()[which(!is.na(long) & !is.na(lat))] |>
                      SharedData$new(group = "locations")
            
            leaflet() |>
                addProviderTiles("CartoDB.Positron") |>
                setView(23.7275, 38, zoom = 6.5) |>
                addCircleMarkers(
                    data = df_map,
                    lng = ~long, lat = ~lat, 
                    stroke = TRUE, fill = TRUE, 
                    color = "#033c73", fillColor = "#2fa4e7",
                    radius = 5, weight = .5,
                    opacity = 1, fillOpacity = .5,
                    
                    popup = ~htmlEscape(
                        paste0(tax_division2, ": ", scientific_name)
                    )
                )
        })
      
        # renderReactable({
        #   
        #     df_table <- df() |>
        #                 SharedData$new(group = "locations")
        #   
        # 
        #     reactable(
        #       df_table()[, c(
        #             "accession", "region", "altitude", "host",
        #             "isolation_source", "scientific_name"
        #         ), with = FALSE],
        #         groupBy = input$group_by,
        #         filterable = input$table_filter |> as.logical(),
        #         theme = reactableTheme( backgroundColor  = "#F3F6FA" ),
        #         paginationType = "jump",
        #         defaultPageSize = 15,
        #         showPageSizeOptions = TRUE,
        #         pageSizeOptions = c(15, 25, 50, 100),
        #         selection = "multiple",
        #         onClick = "select",
        #         rowStyle = list(cursor = "pointer")
        #     )
        # })

      
        
    })
}

abouttextUi <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    renderUI( 
      HTML("
        <div>
          <h3 style='color: #004164;'>Last update</h3>
          <p>This app is updated once every six months.</p>
          <br>
          <h3 style='color: #004164;'>Contribution</h3>
          <p>Your input is invaluable - whether it's suggesting a new chart/analysis or reporting a bug,
             we welcome and greatly appreciate your feedback!</p>
          <p>Feel free to open a <a href='https://github.com/npechl/MBioG/issues' style='color: #004164;'>GitHub issue</a> 
             or contact us via <a href='mailto:inab.bioinformatics@lists.certh.gr' style='color: #004164;'>inab.bioinformatics@lists.certh.gr</a>.</p>
          <br>
          <h3 style='color: #004164;'>MIT license</h3>
          <p>This work, as a whole, is licensed under the <a href='https://github.com/npechl/MBioG/blob/main/LICENSE' style='color: #004164;'>MIT license</a>.</p>
          <p>The code contained in this website is simultaneously available under the MIT license; 
             this means that you are free to use it in your own packages, as long as you cite the source.</p>
          <br>
          <h3 style='color: #004164;'>Authors</h3>
          <p><a href='https://github.com/npechl' style='color: #004164;'>Nikos Pechlivanis <i class='fab fa-github'></i></a></p>
          <p><a href='https://github.com/NatAnastas' style='color: #004164;'>Natasa Anastasiadou <i class='fab fa-github'></i></a></p>
        </div>
      ")
      
    )
    
  })
  
}

downloadServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    downloadHandler(
          filename = function(){
          paste0("MBG table.csv")
          },
      
      content = function(file){
        
        write.csv(df(), file)
      }
    )
    
  })
}
 
plotServer1 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderEcharts4r({
      
      data_p1 <- df()[, c("first_public")]
      
      data_p1$first_public <- ymd(data_p1$first_public)
      
      
      data_p1$year_month <- paste(year(data_p1$first_public), month(data_p1$first_public), sep = "-")
      
      
      data_p1 <- data_p1 |>
        group_by(year_month) |>
        summarize(Dates = n())
      
      
      
      data_p1 |> 
        e_charts(year_month) |> 
        #e_line(Dates, color = "#447197", smooth = TRUE) |>
        e_area(Dates, color = "#447197", smooth = TRUE) |> 
        e_x_axis(axisLabel = list(rotate = 45))|>
        e_legend(show = FALSE) |>
        e_tooltip()
      
      
    })
    
  })
}

plotServer2 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderEcharts4r({
      
      data_plot <- df() |>
        group_by(tax_division2) |>
        summarize(Number_of_taxes = n()) |>
        arrange(desc(Number_of_taxes))
      
      data_plot |>
        e_charts(tax_division2) |>
        e_bar(Number_of_taxes, stack = "grp", color = "#447197" ) |>
        e_x_axis(axisLabel = list(rotate = 45)) |>
        #e_y_axis(axisLabel = list(show = FALSE)) |>
        e_legend(show = FALSE) |>
        e_tooltip()
      
    })
    
  })
}

plotServer3 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderEcharts4r({
      
      data_plot <- df() |>
        group_by(scientific_name) |>
        summarize(Number_of_names = n()) |>
        arrange(desc(Number_of_names)) |>
        filter(Number_of_names > 5)
      
      
      data_plot |>
        e_color_range(Number_of_names, color, colors = c("#064467", "#004164")) |>
        e_charts() |> 
        e_cloud(scientific_name,
                Number_of_names,
                color = color ,
                shape = "circle", 
                rotationRange = c(0, 0),
                sizeRange = c(9, 28)) |>
        e_tooltip()
      
      
    })
    
  })
}


treeServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderEcharts4r({
      
      data_tree <- df()
      
      taxes <- unique(data_tree$tax_division2)
      
      tree_children <- list()
      
      
      for (tax in taxes) {
        
        
        filtered_data <- data_tree[data_tree$tax_division2 == tax, ]
        
        
        values <- unique(filtered_data$scientific_name)
        
        
        tax_tibble <- tibble(name = c(values))
        
        
        tree_children[[tax]] <- tax_tibble
      }
      
      
      tree <- tibble(
        name = "Taxonomy",
        children = list(
          tibble(name = c(taxes), children = tree_children)
        )
      )
      

      
      tree |> 
        e_charts() |> 
        e_tree(
               label = list(
                 position = 'right',
                 verticalAlign = 'middle',
                 fontSize = 12
               ),
               leaves = list(
                 label = list(
                   position = 'right',
                   verticalAlign = 'middle',
                   align = 'left'
                 )
               ),
               symbolSize = 10,
               top = '1%',
               left = '10%',
               bottom = '1%',
               right = '10%',
               initialTreeDepth = 1,
               expandAndCollapse = TRUE,
               animationDuration = 550,
               animationDurationUpdate = 750,
               tooltip = list(trigger = 'item', triggerOn = 'mousemove'),
               itemStyle = list(
                 color = '#447197'  # Change the color of the nodes here
               ),
               emphasis = list(
                 itemStyle = list(
                   borderWidth = 1
                 ),
                 focus = 'descendant',
                 label = list(
                   color = 'black',
                   fontWeight = 'bold'
                 )
               )
        )

      
      
      
     })
    
  })
}

  

