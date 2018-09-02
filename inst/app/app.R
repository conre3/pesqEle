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
u <- "https://github.com/conre3/pesqEle/raw/master/data/pesqEle_2018.rda"
httr::GET(u, httr::write_disk("tmp.rda", overwrite = TRUE))
load("tmp.rda")
file.remove("tmp.rda")
df_pesq <- pesqEle_2018


# UI ----------------------------------------------------------------------
dl <- tags$li(downloadButton("download", label = "Download"), 
              class = "dropdown")
ui <- dashboardPage(
  header = dashboardHeader(title = "Pesquisas Eleitorais 2018", dl),
  skin = "black",
  title = "pesqEle",
  dashboardSidebar(
    tags$p(align="center", "Atualizado em: 31/08/2018"),
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
      # isso nao deveria se chamar abrangência, e sim tipo de pesquisa.
      radioButtons(
        inputId = "abrangencia",
        label = "Incluir",
        choiceNames = c(
          "Todas as pesquisas",
          "Pesquisas para Governador, Senador, Deputado Federal e Deputado Estadual",
          "Apenas pesquisas para presidente"
        ),
        choiceValues = c("todas", "estaduais", "nacionais")
      ),
      # abrangencia é diferente de tipo de pesquisa!
      radioButtons(
        inputId = "pesq_range",
        label = "Abrangência",
        choiceNames = c(
          "Todas as pesquisas",
          "Nacional",
          "Outros (estadual, municipal)"
        ),
        choiceValues = c("todas", "nacional", "outros")
      ),
      radioButtons(
        inputId = "comp_contract_same",
        label = "Contratante é a própria empresa?",
        choiceNames = c(
          "Todas as pesquisas",
          "Sim",
          "Não"
        ),
        choiceValues = c("todas", "sim", "nao")
      ),
      radioButtons(
        inputId = "pesq_origin",
        label = "Origem dos recursos",
        choiceNames = c(
          "Todas as pesquisas",
          "Fundo partidário",
          "Recursos próprios",
          "Vazio"
        ),
        choiceValues = c("todas", "partido", "proprio", "vazio")
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
    ),
    
    tags$span(
      style = "position:fixed; right:18px; bottom:10px; 
      z-index:10; height:30px;",
      tags$a(
        href = "https://www.curso-r.com/",
        target = "_blank",
        tags$img(
          src = "cursor.jpg",
          style = "height:100%; border-radius: 50%;",
          " Powered by curso-r"
        )
      )
    )
  )
)

# Server ------------------------------------------------------------------
server <- function(input, output, session) {
  
  # df_pesq_filtrado <- reactive({
  #   
  #   d <- df_pesq
  #   
  #   # filtro abrangência
  #   if(input$abrangencia == "estaduais") {
  #     d <- dplyr::filter(df_pesq, info_uf != "BR")
  #   } else if (input$abrangencia == "nacionais") {
  #     d <- dplyr::filter(df_pesq, info_uf == "BR")
  #   }
  # 
  #   d
  # })
  
  df_plots <- reactive({
    
    d <- df_pesq
    
    # filtro tipo pesquisa
    if(input$abrangencia == "estaduais") {
      d <- dplyr::filter(df_pesq, info_uf != "BR")
    } else if (input$abrangencia == "nacionais") {
      d <- dplyr::filter(df_pesq, info_uf == "BR")
    }
    
    # filtro abrangência (real)
    if(input$pesq_range == "outros") {
      d <- dplyr::filter(df_pesq, pesq_range != "Nacional")
    } else if (input$pesq_range == "nacional") {
      d <- dplyr::filter(df_pesq, pesq_range == "Nacional")
    }
    
    # filtro contrato
    if (input$comp_contract_same == "sim") {
      d <- dplyr::filter(d, comp_contract_same == "Sim")
    } else if (input$comp_contract_same == "nao") {
      d <- dplyr::filter(d, comp_contract_same == "Não")
    }
    
    # filtro recursos
    if (input$pesq_origin == "partido") {
      d <- dplyr::filter(d, pesq_origin == "Fundo partidario")
    } else if (input$pesq_origin == "proprio") {
      d <- dplyr::filter(d, pesq_origin == "Recursos proprios")
    } else if (input$pesq_origin == "vazio") {
      d <- dplyr::filter(d, pesq_origin == "Vazio")
    }
    
    d
  })
  
  
  callModule(
    module = counts,
    id = "contagens",
    df_pesq = df_plots,
    tabs = reactive({input$tabs})
  )
  
  callModule(
    module = visaogeral,
    id = "visao_geral",
    df_pesq = df_plots
  )
  
  callModule(
    module = estatisticos,
    id = "estatisticos",
    df_pesq = df_plots
  )
  
  callModule(
    module = empresas,
    id = "empresas",
    df_pesq = df_plots
  )
  
  output$download <- downloadHandler(
    filename = stringr::str_glue("pesqEle_{as.character(Sys.Date())}.xlsx"),
    content = function(con) {
      writexl::write_xlsx(df_plots(), con)
    }
  )
  
}

shinyApp(ui = ui, server = server)

