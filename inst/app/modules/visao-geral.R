
# Modules -----------------------------------------------------------------

source("modules/geral/geral-barplot.R")
source("modules/geral/geral-mapacoropletico.R")

# Module UI ---------------------------------------------------------------

visaogeralOutput <- function(id) {
  
  ns <- NS(id)
  
  tabItem(
    tabName = id,
    fluidRow(
      box(
        title = "Pesquisas por mês",
        width = 6,
        height = 500,
        barplotOutput(id = ns("barplot"))
      ),
      box(
        title = "Mapa das pesquisas estaduis",
        width = 6,
        height = 500,
        mapacoropleticoOutput(id = ns("mapa"))
      )
    )
  )
}

# Module server -----------------------------------------------------------


visaogeral <- function(input, output, session, df_pesq) {
  
  callModule(
    module = barplot,
    id = "barplot",
    df_pesq = df_pesq
  )
  
  callModule(
    module = mapacoropletico,
    id = "mapa",
    df_pesq = df_pesq
  )
  
}