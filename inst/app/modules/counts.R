# Module UI ---------------------------------------------------------------

countsOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
    fluidRow(
      shinydashboard::infoBoxOutput(ns("num_pesquisas"), width = 3),
      shinydashboard::infoBoxOutput(ns("num_estatisticos"), width = 3),
      shinydashboard::infoBoxOutput(ns("num_empresas"), width = 3),
      shinydashboard::infoBoxOutput(ns("valor_mediano"), width = 3)
    )
  )
  
}

# Module server -----------------------------------------------------------

counts <- function(input, output, session, df_pesq) {
  
  output$num_pesquisas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Pesquisas",
      value = nrow(df_pesq), 
      icon = icon("users", lib = "font-awesome"),
      color = "blue", 
      fill = TRUE
    )
  })
  
  output$num_estatisticos <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Estatísticos responsáveis",
      value = nrow(dplyr::distinct(df_pesq, stat_nm)), 
      icon = icon("users", lib = "font-awesome"),
      color = "blue", 
      fill = TRUE
    )
  })
  
  output$num_empresas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Empresas",
      value = nrow(dplyr::distinct(df_pesq, comp_nm)), 
      icon = icon("users", lib = "font-awesome"),
      color = "blue", 
      fill = TRUE
    )
  })
  
  output$valor_mediano <- shinydashboard::renderInfoBox({
    
    valor <- (df_pesq$pesq_val/df_pesq$pesq_n) %>% 
      median(rm.na = TRUE) %>% 
      round(2)
    
    shinydashboard::infoBox(
      title = "Valor mediano",
      value = valor, 
      icon = icon("users", lib = "font-awesome"),
      color = "blue", 
      fill = TRUE
    )
  })
  
}