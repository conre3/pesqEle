#' Parse main results
#'
#' Parse main HTML files returned by \code{pesq_download_cities}
#' into \code{tibbles}.
#'
#' @param arqs character vector containing file paths. Valid files have \code{<UF>_<code>.html} format.
#'
#' @return \code{tibble} containing 8 columns.
pesq_parse_main <- function(arqs) {
  f <- purrr::possibly(parse_arq, tibble::tibble(result = 'erro'))
  purrr::map_dfr(purrr::set_names(arqs, arqs), f, .id = "arq")
}

parse_arq <- function(arq) {
  tab <- arq %>%
    xml2::read_html(arq, encoding = 'ISO-8859-1') %>%
    rvest::html_node(xpath = '//table[@id="formPesquisa:listagemPesquisa"]//table')
  tib <- tab %>%
    rvest::html_table() %>%
    tibble::as_tibble() %>%
    purrr::set_names(remove_accents) %>%
    purrr::set_names(clean) %>% 
    dplyr::mutate_all(dplyr::funs(as.character))
  tib
}

parse_detalhes_arq <- function(arq, rds = FALSE) {
  arq_rds <- paste0(tools::file_path_sans_ext(arq), '.rds')
  if (!file.exists(arq_rds)) {
    tabelas <- xml2::read_html(arq) %>%
      rvest::html_nodes(xpath = '//fieldset[@id="j_idt33:j_idt39"]//table')
    infos_basicas <- tabelas[[1]] %>%
      rvest::html_table(fill = TRUE) %>% {
        dplyr::bind_rows(dplyr::select(., X1, X2),
                         dplyr::select(., X1 = X3, X2 = X4))
      } %>%
      limpar_kv()
    contrat <- tabelas[[2]] %>%
      rvest::html_table(fill = TRUE) %>%
      limpar_kv()
    outras_infos <- tabelas[[3]] %>%
      rvest::html_table(fill = TRUE) %>% {
        dplyr::bind_cols(
          dplyr::slice(., seq(1, n(), by = 2)),
          dplyr::slice(., seq(2, n(), by = 2))
        )
      } %>%
      setNames(c('key', 'val')) %>%
      limpar_kv()
    d <- dplyr::bind_rows(infos_basicas, contrat, outras_infos) %>%
      dplyr::filter(!is.na(key)) %>%
      dplyr::mutate(result = 'OK')
    if (rds) saveRDS(d, arq_rds)
    d
  } else {
    readRDS(arq_rds) %>%
      dplyr::mutate(result = 'ja foi')
  }
}

#' Parse details
#'
#' Parse details HTML files returned by \code{pesq_download_cities}
#' into \code{tibbles}.
#'
#' @param arqs character vector containing file paths. Valid files have \code{<UF>_<code>_<result_id>.html} format.
#'
#' @return \code{tibble} containing 3 columns.
#'
pesq_parse_details <- function(arqs) {
  f <- purrr::possibly(parse_detalhes_arq, tibble::tibble(result = 'erro'))
  purrr::map_dfr(purrr::set_names(arqs, arqs), f, .id = "arq")
}

