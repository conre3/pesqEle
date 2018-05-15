# Module UI ---------------------------------------------------------------

statCountsOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
      shinydashboard::infoBoxOutput(ns("num_pesquisas"), width = 12),
      shinydashboard::infoBoxOutput(ns("num_empresas"), width = 12),
      shinydashboard::infoBoxOutput(ns("valor_mediano"), width = 12)
  )
  
}

# Module server -----------------------------------------------------------

statCounts <- function(input, output, session, df_pesq_stat) {
  
  #red, yellow, aqua, blue, light-blue, green, navy, teal, olive, lime, orange, 
  # fuchsia, purple, maroon, black.
  
  output$num_pesquisas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Pesquisas",
      value = nrow(df_pesq_stat()), 
      icon = icon("search", lib = "font-awesome"),
      color = "purple", 
      fill = TRUE
    )
  })
  
  output$num_empresas <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Empresas",
      value = nrow(dplyr::distinct(df_pesq_stat(), comp_nm)), 
      icon = icon("building", lib = "font-awesome"),
      color = "purple", 
      fill = TRUE
    )
  })
  
  output$valor_mediano <- shinydashboard::renderInfoBox({
    
    valor <- median_price(df_pesq_stat()$pesq_val) %>% real_format
    
    shinydashboard::infoBox(
      title = "Valor mediano",
      value = valor, 
      icon = icon("money-bill-alt", lib = "font-awesome"),
      color = "purple", 
      fill = TRUE
    )
  })
  
}