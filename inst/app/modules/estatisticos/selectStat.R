# Module UI ---------------------------------------------------------------

selectStatInput <- function(id) {
  
  ns <- NS(id)
  
  uiOutput(ns("select"))

}

# Module server -----------------------------------------------------------

selectStat <- function(input, output, session, df_pesq) {
  
  output$select <- renderUI({
    
    ns <- session$ns
    
    stat_names <- df_pesq() %>% 
      dplyr::distinct(stat_nm) %>% 
      dplyr::arrange(stat_nm) %>% 
      purrr::flatten_chr()
    
    selectInput(
      inputId = ns("stat_nm"),
      label = "Estatístico responsável",
      choices = stat_names
    )
    
  })
  
  df_pesq_stat <- reactive({
    
    df_pesq() %>% 
      dplyr::filter(stat_nm == input$stat_nm)
    
  })

  return(df_pesq_stat)
}