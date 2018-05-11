
# Modules -----------------------------------------------------------------

source("modules/mapacoropletico.R")

# Module UI ---------------------------------------------------------------

visaogeralOutput <- function(id) {
  
  ns <- NS(id)
  
  tabItem(
    tabName = id,
    fluidRow(
      mapacoropleticoOutput(id = ns("mapa"))
    )
  )
}

# Module server -----------------------------------------------------------


visaogeral <- function(input, output, session, df_pesq) {
  
  callModule(
    module = mapacoropletico,
    id = "mapa",
    df_pesq = df_pesq
  )
  
}