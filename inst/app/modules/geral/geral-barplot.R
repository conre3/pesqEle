
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
    
    df_pesq() %>%
      dplyr::mutate(
        month = lubridate::month(dt_reg, label = TRUE),
        abrangencia = ifelse(info_uf == "BR", "nac", "est"),
        abrangencia = factor(abrangencia, levels = c("nac", "est"))
      ) %>%
      dplyr::count(abrangencia, month) %>% 
      tidyr::complete(abrangencia, month, fill = list(n = 0)) %>% 
      dplyr::filter(month <= lubridate::month(Sys.Date(), label = TRUE)) %>% 
      tidyr::spread(abrangencia, n, fill = 0)
  })
  
  output$plot <- highcharter::renderHighchart({
  
    df_s <- df()
    
    highcharter::highchart() %>%
      highcharter::hc_chart(type = "column") %>% 
      highcharter::hc_xAxis(categories = df_s$month) %>%
      highcharter::hc_add_series(
        df_s$est, 
        name = "Pesquisas para outras posições", 
        showInLegend = TRUE,
        color = "#3399ff") %>% 
      highcharter::hc_add_series(
        df_s$nac, 
        name = "Pesquisas para presidente", 
        showInLegend = TRUE,
        color = "#ff7f50")
    
  })
  
}

