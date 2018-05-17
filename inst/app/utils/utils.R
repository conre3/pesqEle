format_real <- function(x) {
  
  stringr::str_c(
    "R$", 
    format(x, big.mark = ".", nsmall = 2, digits = 2, decimal.mark = ",")
  )
  
}

median_price <- function(x) {
  
  x %>% 
    median(na.rm = TRUE) %>% 
    round(2)
  
}

get_choices <- function(df, variable) {
  
  df %>%
    dplyr::select(x = variable) %>% 
    dplyr::distinct(x) %>% 
    dplyr::arrange(x) %>% 
    purrr::flatten_chr()
  
}

hulk <- function(string) {
  stringr::str_c("<strong>", string, "</strong>")
}

format_cnpj <- function(string) {
  
  stringr::str_c(
    stringr::str_sub(string, 1, 2),
    ".",
    stringr::str_sub(string, 3, 5),
    ".",
    stringr::str_sub(string, 6, 8),
    "/",
    stringr::str_sub(string, 9, 12),
    "-",
    stringr::str_sub(string, 13, 14)
  )
}

format_date <- function(string) {
  
  format(string, format = "%d de %B de %Y")
  
}