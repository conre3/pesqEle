#' Parse main results
#'
#' Parse main HTML files returned by \code{\link{pesq_download_cities}}
#' into \code{tibbles}.
#'
#' @param arqs character vector containing file paths. Valid files have \code{<UF>_<code>.html} format.
#'
#' @return \code{tibble} containing 8 columns, specified in \code{\link{pesq_main}}.
#'
#' @export
pesq_parse_main <- function(arqs) {
  f <- dplyr::failwith(tibble::tibble(result = 'erro'), parse_arq)
  tibble::tibble(arq = arqs) %>%
    dplyr::group_by(arq) %>%
    dplyr::do(f(.$arq)) %>%
    dplyr::ungroup()
}

parse_arq <- function(arq) {
  tab <- arq %>%
    xml2::read_html(arq, encoding = 'ISO-8859-1') %>%
    rvest::html_node(xpath = '//table[@id="formPesquisa:listagemPesquisa"]//table')
  tib <- tab %>%
    rvest::html_table() %>%
    tibble::as_tibble() %>%
    janitor::clean_names() %>%
    purrr::set_names(abjutils::rm_accent(names(.))) %>%
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
#' Parse details HTML files returned by \code{\link{pesq_download_cities}}
#' into \code{tibbles}.
#'
#' @param arqs character vector containing file paths. Valid files have \code{<UF>_<code>_<result_id>.html} format.
#'
#' @return \code{tibble} containing 3 columns, specified in \code{\link{pesq_details}}.
#'
#' @export
pesq_parse_details <- function(arqs) {
  f <- dplyr::failwith(tibble::tibble(result = 'erro'), parse_detalhes_arq)
  tibble::tibble(arq = arqs) %>%
    dplyr::group_by(arq) %>%
    dplyr::do(f(.$arq)) %>%
    dplyr::ungroup()
}

