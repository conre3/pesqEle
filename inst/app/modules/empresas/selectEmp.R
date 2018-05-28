# Module UI ---------------------------------------------------------------

selectEmpInput <- function(id, df_pesq) {
  
  ns <- NS(id)
  
  selectInput(
    width = 750,
    inputId = ns("emp"),
    label = "Empresa",
    choices = get_choices(df_pesq, "comp_nm")
  )
  
}

# Module server -----------------------------------------------------------

selectEmp <- function(input, output, session, df_pesq) {
  
  observeEvent(df_pesq(), {
    
    updateSelectInput(
      session = session,
      inputId = "emp",
      choices = get_choices(df_pesq(), "comp_nm")
    )
    
  })
  
  df_pesq_emp <- reactive({
    
    isolate(df_pesq()) %>% 
      dplyr::filter(comp_nm == input$emp)
    
  })

  return(df_pesq_emp)
  
}