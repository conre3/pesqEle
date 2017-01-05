#' Download CONRE-3 registered companies
#'
#' Downloads CONRE-3 registered companies from CONRE-3 sites.
#'
#' @return \code{tibble} with 5 columns as specified in
#'   \code{\link{conre3_companies}}.
#' @export
conre3_companies <- function() {
  u <- 'http://www.conre3.org.br/portal/profissionais-e-empresas-do-conre-3-2'
  tab <- u %>%
    httr::GET() %>%
    xml2::read_html() %>%
    rvest::html_node('#tab-02 > table') %>%
    rvest::html_table(header = TRUE) %>%
    tibble::as_tibble() %>%
    janitor::clean_names() %>%
    purrr::set_names(abjutils::rm_accent(names(.))) %>%
    dplyr::mutate(cnpj = stringr::str_replace_all(cnpj, '[^0-9]', ''))
  tab
}
