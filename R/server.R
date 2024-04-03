



server <- function(input, output, session) {
    
    df_raw <- datasetServer("source")
    
    df1 <- filterServer("table1", df_raw)
    
    output$table <- tableServer("table1", df1)
    
    output$data_rows <- textServer1("table1", df1)
    
    output$table_statistics <- textServer2("table1", df1)
    
}