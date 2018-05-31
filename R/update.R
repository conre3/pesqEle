#' Downloads and parses all data from 2018 Elections
#' 
#' Downloads HTML files from
#' \href{http://inter01.tse.jus.br/pesqele-publico/}{Brazilian Superior Electoral Court platform}.
#' Then parses all the HTML files, returning a tidy dataset.
#' 
#' @param path directory path to save files. Defaults to 
#'   \code{data-raw/html_2018}.
#' 
#' This function downloads all polls for 2018 elections. It does not delete 
#' existing polls, then it might run faster for the next times. It does
#' subscribe the \code{pesq_main} files, whose contain the list of individual
#' polls. This way you can always run this function pointing to the same 
#' directory, and it will update the polls safely, without downloading 
#' uninportant files. The full download takes about 15 minutes depending on
#' the internet connection.
#' 
#' @return \code{tibble} contaning the same variables as the  
#'   \code{\link{pesqEle_2018}} database.
#' 
#' @export
#' 
#' \donttest{
#' path <- tempdir()
#' pesqEle <- pe_2018(path)
#' }
pe_2018 <- function(path = "data-raw/html_2018") {
  message("Deleting old files...")
  file.remove(dir(path, pattern = "_main_", full.names = TRUE))
  # download 2018 --------------------------------------------------------------
  message("Downloading documents.")
  message("This should take about 15 minutes...")
  pesq_download_2018(path)
  # read and tidy --------------------------------------------------------------
  message("Parsing files...")
  pesq_main <- pesq_parse_main(dir(path, pattern = "_main_", full.names = TRUE))
  pesq_details <- pesq_parse_details(dir(path, pattern = "_details_", full.names = TRUE))
  pesqEle_2018 <- pesq_tidy(pesq_main, pesq_details)
  pesqEle_2018
}
