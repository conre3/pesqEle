
# Module UI ---------------------------------------------------------------

pesqSummaryOutput <- function(id) {
  
  ns <- NS(id)
  
  htmlOutput(ns("summary"))
  
}

# Module server -----------------------------------------------------------

pesqSummary <- function(input, output, session, df_pesq) {
  
  output$summary <- renderUI({
    
    stringr::str_c(
      hulk("Cargo"), ": ", df_pesq()$info_position, 
      "<br>",
      hulk("UF"), ": ", df_pesq()$info_uf, 
      "<br>",
      hulk("Pesquisa registrada em:"), ": ", format_date(df_pesq()$dt_reg), 
      "<br>",
      "<br>",
      hulk("Empresa"), ": ", df_pesq()$comp_nm, 
      "<br>",
      hulk("CNPJ"), ": ", format_cnpj(df_pesq()$comp_cnpj), 
      "<br>",
      "<br>",
      hulk("Valor"), ": ", format_real(df_pesq()$pesq_val), 
      "<br>",
      hulk("Tamanho amostral"), ": ", df_pesq()$pesq_n, 
      "<br>",
      hulk("Custo por unidade amostral"), ": ", 
      format_real(df_pesq()$pesq_val/df_pesq()$pesq_n), 
      "<br>"
    ) %>% 
      HTML()
    
  })
  
}
