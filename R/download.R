pesq_download_city <- function(uf, muni, path) {
  u <- u_tse()
  arq <- sprintf('%s/%s_%s.html', path, uf, muni)
  f <- purrr::possibly(function(item) {
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
  }, 'erro')
  res <- 'ja foi'
  r_pags <- ""
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

pesq_download_details <- function(item, path, date, uf, r0) {
  u <- u_tse()
  fmt <- format(as.Date(date), "%Y%m%d")
  .file_detail <- sprintf('%s/details%s_%s_%03d.html', path, uf, fmt, item + 1)
  result <- 'already exists'
  if (!file.exists(.file_detail)) {
    wd <- httr::write_disk(.file_detail, overwrite = TRUE)
    body <- form_detalhar_date(item, as.Date(date), vs(r0))
    r_details <- httr::POST(u, body = body, encode = 'form')
    httr::GET(u_detalhar(), wd)
    result <- 'OK'
  }
  result
}

pesq_download_day <- function(date, path, uf = "") {
  fmt <- format(as.Date(date), "%Y%m%d")
  .file <- sprintf("%s/pesqEle%s_%s.html", path, uf, fmt)
  .f <- purrr::possibly(pesq_download_details, 'error')
  res <- "existe"
  r_pags <- ""
  if (!file.exists(.file)) {
    u <- u_tse()
    r0 <- httr::GET(u)
    wd <- httr::write_disk(.file, overwrite = TRUE)
    body <- form_tse_date(date, vs(r0), uf)
    r <- httr::POST(u, body = body, encode = "form", wd)
    d_results <- parse_arq(.file)
    # if more than 100 results, breaks download in UFs
    if (nrow(d_results) == 100L) {
      file.remove(.file)
      results <- purrr::map_dfr(ufs(), ~pesq_download_day(date, path, .x))
      return(results)
    } else {
      r_pags <- purrr::map_chr(seq_len(nrow(d_results)) - 1,
                               .f, path = path, date = date,
                               uf = uf, r0 = r0)
    }
    res <- "OK"
  }
  tibble::tibble(result = res, pags = list(r_pags))
}

pesq_download <- function(date = Sys.Date() - 1, path = "data-raw/html") {
  dir.create(path, FALSE, TRUE)
  purrr::map_dfr(date, ~{
    pesq_download_day(.x, path)
  }, .id = "date")
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
#' @param cities \code{tibble} returned from \code{pesq_download_cities} or \code{cities}.
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
#' \donttest{
#' data(cities, package = 'pesqEle')
#' head(cities)
#' d_results <- pesq_download_cities(head(cities))
#' }
pesq_download_cities <- function(cities, path = 'data-raw/html') {
  dir.create(path, FALSE, TRUE)
  .f <- purrr::possibly(pesq_download_city, tibble::tibble(result = 'error'))
  ..f <- function(...) {
    .f(...)
  }
  fmt <- "downloading [:bar] :percent eta: :eta"
  nm <- paste(cities[["uf"]], cities[["muni"]], sep = "_")
  purrr::map2_dfr(purrr::set_names(cities[["uf"]], nm),
                  cities[["muni"]], ..f,
                  path = path, .id = ".id")
}

vs <- function(r) {
  r %>%
    httr::content('text') %>%
    xml2::read_html() %>%
    rvest::html_node(xpath = '//input[@id="javax.faces.ViewState"]') %>%
    rvest::html_attr('value')
}

pesq_download_2018_uf <- function(sigla, path) {
  # funcao que baixa detalhes
  f <- function(id, item) {
    id <- stringr::str_replace_all(id, "[^A-Za-z0-9]+", "-")
    arq_detalhe <- sprintf('%s/pesq_details_%s_%s.html', path, sigla, id)
    if (!file.exists(arq_detalhe)) {
      wd <- httr::write_disk(arq_detalhe, overwrite = TRUE)
      body <- form_detalhar(item - 1L, sigla, "", vs(r0))
      r_detalhe <- httr::POST(u, body = body, encode = 'form')
      httr::GET(u_detalhar(), wd)
      'OK'
    } else {
      'ja foi'
    }
  }
  f <- purrr::possibly(f, "erro")
  # acessa a pagina
  message("Downloading ", sigla, "...")
  .file <- stringr::str_glue("{path}/pesq_main_{sigla}.html")
  u <- u_tse()
  r0 <- httr::GET(u)
  body_uf <- form_tse_estado(sigla, vs(r0))
  r_muni <- httr::POST(u, body = body_uf, encode = 'form')
  # pega resultados por UF
  wd <- httr::write_disk(.file, overwrite = TRUE)
  body <- form_tse_uf_2018(sigla, vs(r0))
  r <- httr::POST(u, body = body, encode = "form", wd)
  d_results <- parse_arq(.file)
  # baixa detalhes
  r_pags <- purrr::imap_chr(d_results$numero_de_identificacao, f)
  tibble::tibble(pags = list(r_pags))
}

pesq_download_2018 <- function(path = "data-raw/html_2018") {
  dir.create(path, FALSE, TRUE)
  uf <- c(ufs(), "BR")
  names(uf) <- uf
  purrr::map_dfr(uf, pesq_download_2018_uf, path = path, .id = "uf")
}

