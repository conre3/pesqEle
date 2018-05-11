#' Update pesq
#'
#' @param data last date
#'
#' @return pesqEle atualizado
#'
#' @export
pesq_update <- function(data = Sys.Date() - 7) {
  tmp <- tempfile()
  dir.create(tmp)
  all_dates <- seq(as.Date(data), Sys.Date(), by = "day")
  purrr::walk(all_dates, pesq_download_day, tmp)
  files_main <- fs::dir_ls(tmp, regexp = "/pesqEle")
  files_details <- fs::dir_ls(tmp, regexp = "/details")
  pesq_main <- pesq_parse_main(files_main)
  pesq_details <- pesq_parse_details(files_details)
  pesq_tidy(pesq_main, pesq_details)
}
