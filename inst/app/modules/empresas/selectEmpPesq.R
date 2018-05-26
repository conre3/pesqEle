# Module UI ---------------------------------------------------------------

selectEmpPesqInput <- function(id, df_pesq) {
  
  ns <- NS(id)
  
  selectInput(
    inputId = ns("pesq"),
    label = "Pesquisa",
    choices = get_choices(
      dplyr::filter(df_pesq, comp_nm == dplyr::first(comp_nm)), 
      "id_pesq"
    )
  )
  
}

# Module server -----------------------------------------------------------

selectEmpPesq <- function(input, output, session, df_pesq) {
  
  observeEvent(df_pesq(), {
    
    updateSelectInput(
      session = session,
      inputId = "pesq",
      choices = get_choices(df_pesq(), "id_pesq")
    )
    
  })
  
  
  df_pesq_emp_pesqid <- reactive({
    
    isolate(df_pesq()) %>% 
      dplyr::filter(id_pesq == input$pesq)
    
  })
  
  return(df_pesq_emp_pesqid)
}