#' Cities list
#'
#' A dataset containing a list of states and city codes from TSE pesqEle platform.
#'
#' @format A data frame with 5571 rows and 2 variables:
#' \describe{
#'   \item{uf}{State initials.}
#'   \item{muni}{City code.}
#' }
#' @source \url{http://inter01.tse.jus.br/pesqele-publico/app/pesquisa/listarEstatisticos.xhtml}
"cities"

#' pesqEle main results
#'
#' A raw dataset containing the results of all the city searches.
#' Cities with zero results are informed but have the column
#' \code{numero_de_identificacao} equal 'Nenhum registro encontrado!'.
#'
#' @format A data frame with 11078 rows and 8 variables:
#' \describe{
#'    \item{arq}{path to the HTML file.}
#'    \item{numero_de_identificacao}{Research id.}
#'    \item{empresa_contratada_nome_fantasia}{Fantasy name of the company.}
#'    \item{no_do_estatistico}{Statistician id.}
#'    \item{nome_do_estatistico}{Statistician name.}
#'    \item{data_de_registro}{Registry date.}
#'    \item{abrangencia}{State / city.}
#'    \item{acoes}{HTML buttons.}
#' }
#' @source \url{http://inter01.tse.jus.br/pesqele-publico/app/pesquisa/listarEstatisticos.xhtml}
"pesq_main"

#' pesqEle details results
#'
#' A raw dataset containing the details of each result.
#'
#' @format A data frame with 210347 rows and 3 variables:
#' \describe{
#'    \item{arq}{path to the HTML file.}
#'    \item{key}{Name of the info.}
#'    \item{val}{Value of the info.}
#' }
#' @source \url{http://inter01.tse.jus.br/pesqele-publico/app/pesquisa/listarEstatisticos.xhtml}
"pesq_details"


#' pesqEle tidy dataset
#'
#' A tidy dataset containing the results of elections polls.
#'
#' @format A data frame with 11078 rows and 8 variables:
#' \describe{
#'    \item{id_seq}{.}
#'    \item{id_pesq}{.}
#'    \item{id_muni}{.}
#'    \item{info_uf}{.}
#'    \item{info_muni}{.}
#'    \item{info_election}{.}
#'    \item{info_position}{.}
#'    \item{comp_nm}{.}
#'    \item{comp_cnpj}{.}
#'    \item{comp_contract_same}{.}
#'    \item{stat_id}{.}
#'    \item{stat_nm}{.}
#'    \item{pesq_n}{.}
#'    \item{pesq_val}{.}
#'    \item{pesq_contractors}{.}
#'    \item{pesq_origin}{.}
#'    \item{pesq_contractors}{.}
#'    \item{pesq_origin}{.}
#'    \item{dt_reg}{.}
#'    \item{dt_pub}{.}
#'    \item{dt_start}{.}
#'    \item{dt_end}{.}
#'    \item{txt_verif}{.}
#'    \item{txt_method}{.}
#'    \item{txt_about}{.}
#'    \item{txt_plan}{.}
#' }
#' @source \url{http://inter01.tse.jus.br/pesqele-publico/app/pesquisa/listarEstatisticos.xhtml}
"pesqEle"


