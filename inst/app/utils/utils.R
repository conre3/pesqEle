real_format <- function(x) {
  
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