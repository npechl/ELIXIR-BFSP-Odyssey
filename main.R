

source("R/libraries.R")

source("R/histogram.R")
source("R/dataset.R")
source("R/selectVar.R")

source("ui.R")
source("server.R")


shinyApp(ui, server)
