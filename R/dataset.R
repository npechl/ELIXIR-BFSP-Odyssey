
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
        
        out = out |>
          dplyr::select(-altitude, -host_tax_id, -tax_division, -tax_id, 
                        -lat, -long, -tag, -location)
        

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
                df(),
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

         renderText({  nrow(df()) |> scales::comma() })

    })
}

textServer2 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderText({ length(unique(df()$tax_division2)) })
    
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
        
        renderText({ length(unique(df()$scientific_name)) })
        
    })
}

textServer5 <- function(id, df) {
  moduleServer(id, function(input, output, session) {
    
    renderText({ length(unique(df()$isolation_source)) })
    
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

