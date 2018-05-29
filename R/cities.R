#' List of cities
#'
#' Downloads list of series according to TSE.
#' It is obtained automatically via web scraping.
#' Needs stable internet connection.
#'
#' @return \code{tibble} with two columns, state name and city code.
#' There's a cached result in \code{cities}.
#'
#' @seealso \code{cities}.
#'
pesq_city_codes <- function() {
  ufs <- c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA",
           "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN",
           "RO", "RR", "RS", "SC", "SE", "SP", "TO")
  u <- u_tse()
  d_munis <- plyr::ldply(ufs, function(uf) {
    r0 <- httr::GET(u)
    r <- httr::POST(u, body = form_tse_estado(uf, vs(r0)), encode = 'form')
    httr::content(r, "text")
    munis <- r %>%
      httr::content('text') %>%
      xml2::read_html() %>%
      xml2::xml_find_first("//update[@id='formPesquisa:selectCidades']/div[2]") %>%
      rvest::html_nodes(xpath = './select[@id="formPesquisa:selectCidades_input"]//option') %>%
      rvest::html_attr('value')
    tibble::tibble(uf = uf, muni = munis)
  }, .progress = 'text')
  d_munis %>%
    dplyr::filter(muni != '') %>%
    tibble::as_tibble()
}
