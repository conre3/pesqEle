# Shape file --------------------------------------------------------------

# df_uf <- sf::st_read(
#   "utils/BRUFE250GC_SIR.shp",
#   stringsAsFactors = FALSE,
#   quiet = TRUE
# )
df_uf_link <- "https://www.dropbox.com/s/dzdw4p1vjolqot8/df_uf.rds?dl=1"
message("Downloading shapefile...")
tmp <- tempfile(pattern = "df_uf_", fileext = ".rds")
httr::GET(df_uf_link, httr::write_disk(tmp, overwrite = TRUE), httr::progress())
df_uf <- readr::read_rds(tmp)
file.remove(tmp)

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
        breaks = quantile(n_pesq),
        include.lowest = TRUE))
  })
  
  output$plot <- renderPlot({
    
    df_aggr() %>% 
      # sf::st_simplify(dTolerance = 0.1) %>% 
      ggplot() +
      geom_sf(aes(fill = n_pesq)) +
      theme_minimal() +
      scale_fill_brewer() +
      labs(fill = "Nº pesquisas")
  })
  
}