# Libraries ---------------------------------------------------------------
library(shiny)
library(shinyBS)
library(shinydashboard)
library(magrittr)
library(ggplot2)
library(sf)

# Functions ---------------------------------------------------------------
source("utils/utils.R")

# Modules -----------------------------------------------------------------
source("modules/visao-geral.R")
source("modules/counts.R")
source("modules/estatisticos.R")
source("modules/empresas.R")
source("modules/sobre.R")

# Data --------------------------------------------------------------------
df_pesq <- pesqEle::pesqEle_2018

# UI ----------------------------------------------------------------------
dl <- tags$li(downloadButton("download", label = "Download"), 
              class = "dropdown")
ui <- dashboardPage(
  header = dashboardHeader(title = "Pesquisas Eleitorais 2018", dl),
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
        text = "Estatísticos Responsáveis",
        tabName = "estatisticos",
        icon = shiny::icon("users")
      ),
      menuItem(
        text = "Saiba mais",
        href = "http://www.conre3.org.br/portal/pesquisa-eleitoral/",
        icon = shiny::icon("lightbulb")
      ),
      menuItem(
        text = "Sobre",
        tabName = "sobre",
        icon = shiny::icon("info-circle")
      ),
      tags$hr(),
      radioButtons(
        inputId = "abrangencia",
        label = "Incluir",
        choiceNames = c(
          "Todas as pesquisas",
          "Apenas pesquisas estaduais",
          "Apenas pesquisas nacionais"
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
    
    shinyjs::useShinyjs(),
    shinyBS::bsPopover(
      id = "placehodelr",
      title = "",
      content = "place-holder"),
    
    countsOutput(id = "contagens"),
    
    tabItems(
      visaogeralUI(id = "visao_geral"),
      estatisticosUI(id = "estatisticos", df_pesq = df_pesq),
      empresasUI(id = "empresas", df_pesq = df_pesq),
      sobreUI(id = "sobre")
    )
    
  )
)

# Server ------------------------------------------------------------------
server <- function(input, output, session) {
  
  df_pesq_filtrado <- reactive({
    
    if(input$abrangencia == "todas") {
      df_pesq
    } else if(input$abrangencia == "estaduais") {
      dplyr::filter(df_pesq, info_uf != "BR")
    } else {
      dplyr::filter(df_pesq, info_uf == "BR")
    }
    
  })
  
  callModule(
    module = counts,
    id = "contagens",
    df_pesq = df_pesq_filtrado,
    tabs = reactive({input$tabs})
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
  
  callModule(
    module = empresas,
    id = "empresas",
    df_pesq = df_pesq_filtrado
  )
  
  output$download <- downloadHandler(
    filename = stringr::str_glue("pesqEle_{as.character(Sys.Date())}.xlsx"),
    content = function(con) {
      writexl::write_xlsx(df_pesq_filtrado(), con)
    }
  )
  
}

shinyApp(ui = ui, server = server)

