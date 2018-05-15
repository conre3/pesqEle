# Libraries ---------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(magrittr)
library(ggplot2)


# Functions ---------------------------------------------------------------

source("utils/utils.R")

# Modules -----------------------------------------------------------------

source("modules/visao-geral.R")
source("modules/counts.R")
source("modules/estatisticos.R")

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
        icon = shiny::icon("globe")
      ),
      menuItem(
        text = "Empresas",
        tabName = "empresas",
        icon = shiny::icon("building")
      ),
      menuItem(
        text = "Estatísticos",
        tabName = "estatisticos",
        icon = shiny::icon("users")
      ),
      tags$hr(),
      radioButtons(
        inputId = "abrangencia",
        label = "Incluir",
        choiceNames = c(
          "Todas as pesquisas",
          "Apenas pesquisas estaduais",
          "Apenas pesquisas estaduais"
          ),
        choiceValues = c("todas", "estaduais", "nacionais")
      )
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet", 
        type = "text/css",  
        href="https://use.fontawesome.com/releases/v5.0.9/css/all.css")
    ),
    countsOutput(id = "contagens"),
    tabItems(
      visaogeralUI(id = "visao_geral"),
      estatisticosUI(id = "estatisticos")
    )
  )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  df_pesq_filtrado <- reactive({
    
    if(input$abrangencia == "todas") {
      df_pesq
    } else if(input$abrangencia == "estaduais") {
      dplyr::filter(df_pesq, info_uf != "BRASIL")
    } else {
      dplyr::filter(df_pesq, info_uf == "BRASIL")
    }
    
  })
  
  callModule(
    module = counts,
    id = "contagens",
    df_pesq = df_pesq_filtrado
  )
  
  callModule(
    module = visaogeral,
    id = "visao_geral",
    df_pesq = df_pesq
  )
  
  callModule(
    module = estatisticos,
    id = "estatisticos",
    df_pesq = df_pesq_filtrado
  )
  
}

shinyApp(ui = ui, server = server)

