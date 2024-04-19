



server <- function(input, output, session) {
    
    df_raw <- datasetServer("source")
    
    df1 <- filterServer("table1", df_raw)
    
    output$table <- tableServer("table1", df1)
    
    output$map <- mapServer("map", df1)
    
    output$data_rows <- textServer1("table1", df1)
    
    output$tax_division <- textServer2("table1", df1)
    
    # output$tags <- textServer3("table1", df1)
    
    output$names <- textServer4("table1", df1)
    
    output$isolation_source <- textServer5("table1", df1)
    
    output$about <- abouttextUi("about")
    
    output$download <- downloadServer("table1", df1)
    
    output$plot1 <-  plotServer("table1", df1)
    

}