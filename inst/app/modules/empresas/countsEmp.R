# Module UI ---------------------------------------------------------------

countsEmpOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
      shinydashboard::infoBoxOutput(ns("num_pesquisas"), width = 12),
      shinydashboard::infoBoxOutput(ns("num_estatisticos"), width = 12),
      shinydashboard::infoBoxOutput(ns("valor_mediano"), width = 12)
  )
  
}

# Module server -----------------------------------------------------------

countsEmp <- function(input, output, session, df_pesq_stat) {
  
  output$num_pesquisas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Pesquisas",
      value = nrow(df_pesq_stat()), 
      icon = icon("search", lib = "font-awesome"),
      color = "purple", 
      fill = TRUE
    )
  })
  
  output$num_estatisticos <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Estatísticos",
      value = nrow(dplyr::distinct(df_pesq_stat(), stat_nm)), 
      icon = icon("users", lib = "font-awesome"),
      color = "purple", 
      fill = TRUE
    )
  })
  
  output$valor_mediano <- shinydashboard::renderInfoBox({
    
    valor <- median_price(df_pesq_stat()$pesq_val) %>% format_real
    
    shinydashboard::infoBox(
      title = "Valor mediano",
      value = valor, 
      icon = icon("money-bill-alt", lib = "font-awesome"),
      color = "purple", 
      fill = TRUE
    )
  })
  
}