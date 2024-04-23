
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
                pageSizeOptions = c(15, 25, 50, 100)
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

# textServer3 <- function(id, df) {
#   moduleServer(id, function(input, output, session) {
# 
#     renderText({ length(unique(df()$tag1)) })
# 
#   })
# }

textServer4 <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        renderText({ df()$scientific_name |> unique() |> length() })
        
    })
}

textServer5 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderText({ df()$isolation_source |> unique() |> length() })
    
  })
}

mapServer <- function(id, df) {
    moduleServer(id, function(input, output, session) {
        
        renderLeaflet({
            
            df_s <- df()[which(!is.na(long) & !is.na(lat))]
            
            leaflet() |>
                addProviderTiles("CartoDB.Positron") |>
                setView(23.7275, 38, zoom = 6.5) |>
                addCircleMarkers(
                    data = df_s,
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
 
plotServer <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderEcharts4r({
      
      data_plot <- df() |>
        group_by(tax_division2) |>
        summarize(Number_of_taxes = n()) |>
        arrange(desc(Number_of_taxes))
      
      data_plot |>
        e_charts(tax_division2) |>
        e_bar(Number_of_taxes, stack = "grp") |>
        e_x_axis(axisLabel = list(rotate = 45)) |>
        #e_y_axis(axisLabel = list(show = FALSE)) |>
        e_legend(show = FALSE) |>
        e_tooltip()
      
    })
    
  })
}
  

