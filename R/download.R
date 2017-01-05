pesq_download_city <- function(uf, muni, path) {
  u <- u_tse()
  arq <- sprintf('%s/%s_%s.html', path, uf, muni)
  f <- dplyr::failwith('erro', function(item) {
    arq_detalhe <- sprintf('%s/%s_%s_%03d.html', path, uf, muni, item + 1)
    if (!file.exists(arq_detalhe)) {
      wd <- httr::write_disk(arq_detalhe, overwrite = TRUE)
      body <- form_detalhar(item, uf, muni, vs(r0))
      r_detalhe <- httr::POST(u, body = body, encode = 'form')
      httr::GET(u_detalhar(), wd)
      'OK'
    } else {
      'ja foi'
    }
  })
  res <- 'ja foi'
  if (!file.exists(arq)) {
    r0 <- httr::GET(u)
    r_muni <- httr::POST(u, body = form_tse_estado(uf, vs(r0)), encode = 'form')
    ftm <- form_tse_muni(uf, muni, vs(r0))
    wd <- httr::write_disk(arq, overwrite = TRUE)
    r <- httr::POST(u, body = ftm, encode = 'form', wd)
    d_results <- parse_arq(arq)
    r_pags <- sapply(0:(nrow(d_results) - 1), f)
    res <- 'OK'
  }
  tibble::tibble(result = res, pags = list(r_pags))
}

#' Downloads pesqEle files
#'
#' Downloads HTML files from
#' \href{http://inter01.tse.jus.br/pesqele-publico/app/pesquisa/listarEstatisticos.xhtml}{TSE pesqEle platform}.
#' Receives a \code{tibble} containing cities and saves HTML files for each city.
#' When the search for one city returns one or more results,
#' this function will save one HTML file for each result plus the list of results.
#' Otherwise, it will save just one HTML file showing zero results.
#'
#' @param cities \code{tibble} returned from \code{\link{pesq_download_cities}} or \code{\link{cities}}.
#' @param path directory to save HTML files.
#'
#' For example, consider the city of Rio de Janeiro (code 60011).
#' If one searches this city in pesqEle platform,
#' she will get 47 results. This function will save 48 files,
#' where the first one is \code{RJ_60011.html} and the others are
#' \code{RJ_60011_xxx}, \code{xxx} from 001 to 047 indicating
#' each individual result.
#'
#' @return \code{tibble} containing download status: 'OK' if it ran well,
#' 'ja foi' if the file already exists and 'erro' if there was an error.
#'
#' @examples
#' \dontrun{
#' data(cities, package = 'pesqEle')
#' head(cities)
#' d_results <- pesq_download_cities(head(cities))
#' }
#'
#' @export
pesq_download_cities <- function(cities, path = 'data-raw/html') {
  f <- dplyr::failwith(tibble::tibble(result = 'erro'), pesq_download_city)
  cities %>%
    dplyr::group_by(uf, muni) %>%
    dplyr::do(f(uf = .$uf, muni = .$muni, path = path)) %>%
    dplyr::ungroup()
}

#' Viewstate
#'
#' Capture viewstate from response object.
#'
#' @param r response object.
vs <- function(r) {
  r %>%
    httr::content('text') %>%
    xml2::read_html() %>%
    rvest::html_node(xpath = '//input[@id="javax.faces.ViewState"]') %>%
    rvest::html_attr('value')
}

