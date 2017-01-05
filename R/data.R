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

#' CONRE-3 registered companies
#'
#' A raw dataset containing registered companies scraped from CONRE-3 site.
#'
#' @format A data frame with 133 rows and 5 variables:
#' \describe{
#'    \item{razao_social}{Name of the company.}
#'    \item{uf}{State initials.}
#'    \item{cnpj}{Company national id.}
#'    \item{no_registro_conre_3}{CONRE3 id.}
#'    \item{estatistico_responsavel}{Name of the statistitian.}
#' }
#' @source \url{http://www.conre3.org.br/portal/profissionais-e-empresas-do-conre-3-2/}
"conre3_companies"

