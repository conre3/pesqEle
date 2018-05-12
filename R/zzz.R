globalVariables(c('.', 'X1', 'X2', 'X3', 'X4', 'arq', 'cnpj',
                  'key', 'muni', 'n', 'setNames', 'uf', 'val',
                  'acoes', 'arq_id', 'cargo', 'contratante_propria_empresa',
                  'contratantes', 'criterio_origem', 'dt_divulgacao',
                  'dt_inicio', 'dt_registro', 'dt_termino', 'eleicao',
                  'emp_nm', 'empresa', 'empresa_contratada',
                  'estatistico_registro', 'id', 'id_pesq', 'id_seq',
                  'info_election', 'metodologia_pesquisa', 'municipio',
                  'n_entrevistados', 'numero_de_identificacao', 'origem',
                  'plano_amostral', 'result', 'sobre_municipio',
                  'stat_id', 'stat_nm', 'temp', 'valor', 'verificacao'))

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

ufs <- function() {
  c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA",
    "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN",
    "RO", "RR", "RS", "SC", "SE", "SP", "TO")
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
