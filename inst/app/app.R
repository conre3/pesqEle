# Libraries ---------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(magrittr)
library(ggplot2)

# Modules -----------------------------------------------------------------

source("modules/visao-geral.R")
source("modules/counts.R")

# Data --------------------------------------------------------------------

df_pesq <- readr::read_rds("data/pesqEle2018.rds")

# UI ----------------------------------------------------------------------

ui <- dashboardPage(
  header = dashboardHeader(title = "Pesquisas eleitorais"),
  skin = "black",
  title = "pesqEle",
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem(
        text = "Visão geral", 
        tabName = "visao_geral", 
        icon = shiny::icon("info")
      ),
      menuItem(
        text = "Estatísticos responsáveis",
        tabName = "estatisticos",
        icon = shiny::icon("info")
      ),
      menuItem(
        text = "Valor das pesquisas",
        tabName = "valor",
        icon = shiny::icon("info")
      )
    )
  ),
  dashboardBody(
    countsOutput(id = "contagens"),
    tabItems(
      visaogeralOutput(id = "visao_geral")
    )
  )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  callModule(
    module = counts,
    id = "contagens",
    df_pesq = df_pesq
  )
  
  callModule(
    module = visaogeral,
    id = "visao_geral",
    df_pesq = df_pesq
  )

  
  
}

shinyApp(ui = ui, server = server)

