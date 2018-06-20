
# Module UI ---------------------------------------------------------------

barplotOutput <- function(id) {
  ns <- NS(id)
  
  tags$div(
    highcharter::highchartOutput(ns("plot"))  
  )
}

# Module server -----------------------------------------------------------

barplot <- function(input, output, session, df_pesq) {
  
  df <- reactive({
    
    df_pesq %>%
      dplyr::mutate(
        month = lubridate::month(dt_reg, label = TRUE),
        abrangencia = ifelse(info_uf == "BR", "nac", "est")
      ) %>%
      dplyr::count(abrangencia, month) %>% 
      tidyr::spread(abrangencia, n)
  })
  
  output$plot <- highcharter::renderHighchart({
  
    df_s <- df()
    
    highcharter::highchart() %>%
      highcharter::hc_chart(type = "column") %>% 
      highcharter::hc_xAxis(categories = df_s$month) %>%
      highcharter::hc_add_series(
        df_s$est, 
        name = "Pesquisas estaduais", 
        showInLegend = TRUE,
        color = "#3399ff") %>% 
      highcharter::hc_add_series(
        df_s$nac, 
        name = "Pesquisas nacionais", 
        showInLegend = TRUE,
        color = "#ff7f50")
    
  })
  
}

