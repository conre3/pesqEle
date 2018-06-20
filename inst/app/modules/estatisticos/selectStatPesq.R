# Module UI ---------------------------------------------------------------

selectStatPesqInput <- function(id, df_pesq) {
  
  ns <- NS(id)
  
  selectInput(
    inputId = ns("pesq"),
    label = "Pesquisa",
    choices = get_choices(
      dplyr::filter(df_pesq, stat_nm == dplyr::first(stat_nm)), 
      "id_pesq"
    )
  )
  
}

# Module server -----------------------------------------------------------

selectStatPesq <- function(input, output, session, df_pesq) {
  
  observeEvent(df_pesq(), {
    
    updateSelectInput(
      session = session,
      inputId = "pesq",
      choices = get_choices(df_pesq(), "id_pesq")
    )
    
  })
  
  
  df_pesq_stat_pesqid <- reactive({
    
    isolate(df_pesq()) %>% 
      dplyr::filter(id_pesq == input$pesq)
    
  })
  
  return(df_pesq_stat_pesqid)
}