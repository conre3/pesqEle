
# Module UI ---------------------------------------------------------------

tableStatOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
    DT::dataTableOutput(ns("table_stat"))
  )
  
}

# Module server -----------------------------------------------------------

tableStat <- function(input, output, session, df_pesq) {
  
  output$table_stat <- DT::renderDataTable({
    
    df_pesq() %>% 
      dplyr::group_by(stat_nm) %>% 
      dplyr::summarise(
        `Nº pesquisas` = n(),
        `Nº empresas` = dplyr::n_distinct(comp_nm),
        `VMP* (R$)` = median_price(pesq_val),
        `VMUA** (R$)` = median_price(pesq_val/pesq_n)
      ) %>% 
      DT::datatable(
        rownames = FALSE, 
        options = list(pageLength = 5)
      )
  })
  
}
