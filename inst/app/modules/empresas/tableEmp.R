
# Module UI ---------------------------------------------------------------

tableEmpOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
    DT::dataTableOutput(ns("table_emp"))
  )
  
}

# Module server -----------------------------------------------------------

tableEmp <- function(input, output, session, df_pesq) {
  
  output$table_emp <- DT::renderDataTable({
    
    df_pesq() %>% 
      dplyr::group_by(comp_nm) %>% 
      dplyr::summarise(
        `Nº pesquisas` = n(),
        `Nº estatísticos` = dplyr::n_distinct(stat_nm),
        `VMP* (R$)` = median_price(pesq_val),
        `VMUA** (R$)` = median_price(pesq_val/pesq_n)
      ) %>% 
      DT::datatable(
        rownames = FALSE, 
        options = list(pageLength = 5)
      )
  })
  
}
