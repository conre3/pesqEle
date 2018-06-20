# Module UI ---------------------------------------------------------------

countsOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
    id = ns("contagens"),
    fluidRow(
      shinydashboard::infoBoxOutput(ns("num_pesquisas"), width = 3),
      shinyBS::bsPopover(
        id = ns("num_pesquisas"),
        title = "",
        content = "Número de pesquisas registradas."
      ),
      
      shinydashboard::infoBoxOutput(ns("num_estatisticos"), width = 3),
      shinyBS::bsPopover(
        id = ns("num_estatisticos"),
        title = "",
        content = "Total de estatísticos registrados como responsáveis pelas pesquisas."
      ),
      
      shinydashboard::infoBoxOutput(ns("num_empresas"), width = 3),
      shinyBS::bsPopover(
        id = ns("num_empresas"),
        title = "",
        content = "Total de empresas responsáveis pelas pesquisas."
      ),
      
      shinydashboard::infoBoxOutput(ns("valor_mediano"), width = 3),
      shinyBS::bsPopover(
        id = ns("valor_mediano"),
        title = "",
        content = "Valor mediano das pesquisas registradas."
      )
    )
  )
  
}

# Module server -----------------------------------------------------------

counts <- function(input, output, session, df_pesq, tabs) {
  
  output$num_pesquisas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Pesquisas",
      value = nrow(df_pesq()), 
      icon = icon("search", lib = "font-awesome"),
      color = "blue", 
      fill = TRUE
    )
  })
  
  output$num_estatisticos <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Estatísticos",
      value = nrow(dplyr::distinct(df_pesq(), stat_nm)), 
      icon = icon("users", lib = "font-awesome"),
      color = "yellow", 
      fill = TRUE
    )
  })
  
  output$num_empresas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Empresas",
      value = nrow(dplyr::distinct(df_pesq(), comp_nm)), 
      icon = icon("building", lib = "font-awesome"),
      color = "red", 
      fill = TRUE
    )
  })
  
  output$valor_mediano <- shinydashboard::renderInfoBox({
    
    valor <- median_price(df_pesq()$pesq_val) %>% format_real
    
    shinydashboard::infoBox(
      title = "Valor mediano",
      value = valor, 
      icon = icon("money-bill-alt", lib = "font-awesome"),
      color = "green", 
      fill = TRUE
    )
  })
  
  shiny::observeEvent(tabs(), {
    if(tabs() == "") return(NULL)
    if(tabs() == "sobre") {
      shinyjs::hide("contagens", anim = TRUE) 
    } else {
      shinyjs::show("contagens", anim = TRUE)
    }
  }) 
  
}