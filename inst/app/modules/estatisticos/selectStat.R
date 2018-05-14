# Module UI ---------------------------------------------------------------

selectStatInput <- function(id, df_pesq) {
  
  ns <- NS(id)
  
  stat_names <- df_pesq %>% 
    dplyr::distinct(stat_nm) %>% 
    dplyr::arrange(stat_nm) %>% 
    purrr::flatten_chr()
  
  selectInput(
    inputId = "stat_nm",
    label = "Estatístico responsável",
    choices = stat_names
  )

}

# Module server -----------------------------------------------------------

selectStat <- function(input, output, session, df_pesq) {
  
  observeEvent(df_pesq(), {
    
    # stat_names <- df_pesq() %>% 
    #   dplyr::distinct(stat_nm) %>% 
    #   dplyr::arrange(stat_nm) %>% 
    #   purrr::flatten_chr()
    
    updateSelectInput(
      session,
      "stat_nm",
      choices = 7655
    )
    
  })
  
  df_pesq_stat <- reactive({
    
    df_pesq() %>% 
      dplyr::filter(stat_nm == input$stat_nm)
    
  })

  return(df_pesq_stat)
}