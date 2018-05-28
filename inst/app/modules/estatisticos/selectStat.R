# Module UI ---------------------------------------------------------------

selectStatInput <- function(id, df_pesq) {
  
  ns <- NS(id)
  
  selectInput(
    width = 400,
    inputId = ns("stat"),
    label = "Estatístico responsável",
    choices = get_choices(df_pesq, "stat_nm")
  )
  
}

# Module server -----------------------------------------------------------

selectStat <- function(input, output, session, df_pesq) {
  
  observeEvent(df_pesq(), {
    
    updateSelectInput(
      session = session,
      inputId = "stat",
      choices = get_choices(df_pesq(), "stat_nm")
    )
    
  })
  
  df_pesq_stat <- reactive({
    
    isolate(df_pesq()) %>% 
      dplyr::filter(stat_nm == input$stat)
    
  })

  return(df_pesq_stat)
  
}