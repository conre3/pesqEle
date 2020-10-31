arrumar_nm <- function(x) {
  x %>% 
    abjutils::rm_accent() %>% 
    toupper() %>% 
    stringr::str_remove_all("[^A-Z -]") %>% 
    stringr::str_remove_all("CERTIFICADO.*") %>% 
    stringr::str_squish()
}

#' Clean pesqEle data
#' 
#' Clean pesqEle data using simple heuristics. These heuristics may be
#'   incomplete and sometimes even wrong. To have complete control of what
#'   you're doing, consider using the raw data.
#'
#' @param da_pesqele Data obtained using [pesqele_fetch()].
#' 
#' @export
pesqele_tidy <- function(da_pesqele) {
  da_pesqele %>% 
    dplyr::mutate(
      dt_geracao = lubridate::dmy(dt_geracao),
      nm_estatistico_resp = arrumar_nm(nm_estatistico_resp)
    )
}


