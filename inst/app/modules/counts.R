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
    
    real <- function(x) {
      
      stringr::str_c(
        "R$", 
        format(x, big.mark = ".", nsmall = 2, digits = 2, decimal.mark = ",")
      )
      
    }
    
    valor <- median(df_pesq()$pesq_val, rm.na = TRUE) %>% real()
    
    shinydashboard::infoBox(
      title = "Valor mediano",
      value = valor, 
      icon = icon("money-bill-alt", lib = "font-awesome"),
      color = "green", 
      fill = TRUE
    )
  })
  
}