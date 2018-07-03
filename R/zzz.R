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
                  'stat_id', 'stat_nm', 'temp', 'valor', 'verificacao',
                  'stat_unique', 'txt_about'))

limpar_kv <- function(d) {
  d %>%
    tibble::as_tibble() %>%
    setNames(c('key', 'val')) %>%
    dplyr::mutate(key = stringr::str_replace_all(key, ':$', ''))
}

remove_accents <- function(x) {
  stringr::str_replace_all(iconv(x, to = "ASCII//TRANSLIT"), "[`'\"^~]", "")
}

ufs <- function() {
  c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA",
    "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN",
    "RO", "RR", "RS", "SC", "SE", "SP", "TO")
}

parse_reais <- function(x) {
  as.numeric(gsub(",", ".", gsub("[^0-9,]", "", x)))
}

clean <- function(x) {
  gsub(" +", "_", gsub("[^a-z0-9]", " ", stringr::str_trim(tolower(x))))
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
