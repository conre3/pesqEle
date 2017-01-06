globalVariables(c('.', 'X1', 'X2', 'X3', 'X4', 'arq', 'cnpj',
                  'key', 'muni', 'n', 'setNames', 'uf', 'val'))

limpar_kv_spr <- function(d) {
  d %>%
    dplyr::filter(!is.na(key)) %>%
    tidyr::spread(key, val) %>%
    janitor::clean_names() %>%
    purrr::set_names(abjutils::rm_accent(names(.)))
}

limpar_kv <- function(d) {
  d %>%
    tibble::as_tibble() %>%
    setNames(c('key', 'val')) %>%
    dplyr::mutate(key = stringr::str_replace_all(key, ':$', ''))
}

#' Pipe operator
#'
#' See \code{\link[magrittr]{\%>\%}} for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL
