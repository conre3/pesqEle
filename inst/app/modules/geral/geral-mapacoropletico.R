# Shape file --------------------------------------------------------------

# df_uf <- sf::st_read(
#   "utils/BRUFE250GC_SIR.shp",
#   stringsAsFactors = FALSE,
#   quiet = TRUE
# )

message("Please install ufshape package first")
message("devtools::install_github('jtrecenti/ufshape')")
df_uf <- ufshape::df_uf

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
      dplyr::filter(info_uf != "BR") %>%
      dplyr::group_by(info_uf) %>%
      dplyr::summarise(n_pesq = n()) %>%
      dplyr::rename(uf = info_uf) %>%
      dplyr::inner_join(pesqEle::ufs, "uf") %>% 
      dplyr::right_join(df_uf, by = "CD_GEOCUF") %>% 
      dplyr::mutate(n_pesq = ifelse(is.na(n_pesq), 0, n_pesq)) %>% 
      dplyr::mutate(n_pesq = cut(
        x = n_pesq, 
        breaks = c(-1, quantile(n_pesq)),
        include.lowest = TRUE
      )) %>% 
      dplyr::mutate(n_pesq = forcats::fct_recode(n_pesq, "0" = "[-1,0]"))
  })
  
  output$plot <- renderPlot({
    
    df_aggr() %>% 
      # sf::st_simplify(dTolerance = 0.1) %>% 
      ggplot() +
      geom_sf(aes(fill = n_pesq)) +
      theme_minimal() +
      scale_fill_brewer() +
      labs(fill = "Nº pesquisas") +
      theme(axis.text = element_blank())
  })
  
}