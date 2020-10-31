#' Download and read data from TSE
#' 
#' @param year character vector of election years.
#'   Defaults to [available_years()].
#' @param uf character vector of states in UF code, like `c("AC", "BA")`. 
#'   Defaults to `all`, which gets all available UFs.
#' 
#' @seealso [available_years()]
#' 
#' @export
pesqele_fetch <- function(year = available_years(), uf = "all") {
  da <- purrr::map_dfr(year, pesqele_fetch_year, uf, .id = "year")
  names(da) <- tolower(names(da))
  da$uf_file <- fs::path_file(da$uf_file)
  da
}

#' List available years
#' 
#' Obtain available years directly from TSE site.
#' 
#' @return character vector of available years.
#' 
#' @export
available_years <- function() {
  u <- paste0(
    "https://www.tse.jus.br/hotsites/pesquisas-eleitorais",
    "/pesquisas_eleitorais.html"
  )
  r <- httr::GET(u)
  r %>% 
    xml2::read_html() %>% 
    xml2::xml_find_all("//div[contains(@class, 'navegacao_anos')]/ul/li/a") %>% 
    xml2::xml_attr("href") %>% 
    fs::path_file() %>% 
    fs::path_ext_remove()
}

pesqele_fetch_year <- function(year, uf) {
  message(paste("Downloading and processing", year, "data..."))
  if (uf == "all") {
    uf <- "." 
  } else {
    uf <- toupper(paste0(uf, "|"))
  }
  uf <- paste0("(", uf, ")\\.csv")
  tmpdir <- fs::file_temp()
  fs::dir_create(tmpdir)
  on.exit(fs::dir_delete(tmpdir))
  u <- paste0(
    "http://agencia.tse.jus.br/estatistica/sead/odsele/",
    "pesquisa_eleitoral/pesquisa_eleitoral_",
    year, ".zip"
  )
  f <- paste0(tmpdir, "/pesq.zip")
  httr::GET(u, httr::write_disk(f, TRUE), httr::progress())
  utils::unzip(f, exdir = tmpdir)
  csv_files <- fs::dir_ls(tmpdir, regexp = uf)
  loc <- readr::locale(
    encoding = "latin1", 
    grouping_mark = ".", 
    decimal_mark = ","
  )
  cols <- readr::cols(
    .default = readr::col_character(),
    HH_GERACAO = readr::col_time(format = ""),
    AA_ELEICAO = readr::col_double(),
    CD_ELEICAO = readr::col_double(),
    QT_ENTREVISTADOS = readr::col_double(),
    VR_PESQUISA = readr::col_double()
  )
  purrr::map_dfr(
    csv_files, 
    readr::read_csv2, 
    locale = loc, 
    col_types = cols, 
    .id = "uf_file"
  )
}