# Shape file --------------------------------------------------------------

df_uf <- sf::st_read(
  "utils/BRUFE250GC_SIR.shp",
  stringsAsFactors = FALSE,
  quiet = TRUE
)

# Module UI ---------------------------------------------------------------

mapacoropleticoOutput <- function(id) {
  
  ns <- NS(id)
  
  tags$div(
    plotOutput(ns("plot"))
  )
  
}

# Module server -----------------------------------------------------------

mapacoropletico <- function(input, output, session, df_pesq) {
  
  df_aggr <- reactive({
    
    df_pesq %>% 
      dplyr::filter(info_uf != "BRASIL") %>%
      dplyr::group_by(info_uf) %>%
      dplyr::summarise(n_pesq = n()) %>%
      dplyr::rename(NM_ESTADO = info_uf) %>%
      dplyr::right_join(df_uf, by = "NM_ESTADO") %>% 
      dplyr::mutate(n_pesq = ifelse(is.na(n_pesq), 0, n_pesq)) %>% 
      dplyr::mutate(n_pesq = cut(
        x = n_pesq, 
        breaks = quantile(n_pesq),
        include.lowest = TRUE))
    
  })
  
  output$plot <- renderPlot({
    
    ggplot(df_aggr()) +
      geom_sf(aes(fill = n_pesq)) +
      theme_minimal() +
      scale_fill_brewer() +
      labs(fill = "Nº pesquisas")
  })
  
}