library(shiny)
library(shinydashboard)
library(tidyverse)

pesq_details <- read_rds("~/Downloads/pesq_details (1).rds")
pesq_main <- read_rds("~/Downloads/pesq_main (1).rds")

pesq_main_tidy <- pesq_main %>%
    filter(numero_de_identificacao != 'Nenhum registro encontrado!') %>%
    set_names(c('arq', 'id', 'empresa', 'id_stat', 'nm_stat',
                'dt_reg', 'abrangencia', 'acoes')) %>%
    select(arq:abrangencia) %>%
    separate(abrangencia, c('uf', 'muni'), sep = ' / ', fill = "right") %>%
    mutate(nm_stat = rslp:::remove_accents(toupper(nm_stat))) %>%
    mutate(arq_id = str_extract(arq, "([0-9A-Z_)]+)(?=\\.)")) %>%
    distinct(arq_id, id, .keep_all = TRUE)

re_origem <- "(?<=Origem do Recurso: )([a-zA-Z()\\s]+)"
re_cnpj <- "(?<=CNPJ:\\s{1,5})([0-9]+)"

clean_emp <- function(x) {
    re <- "(?<=CNPJ:\\s{1,5}[0-9]{14}\\s{1,3}-)((.|\n)+)"
    x %>%
        stringr::str_extract(re) %>%
        stringr::str_squish() %>%
        stringr::str_to_upper()
}

pesq_details_tidy <- pesq_details %>%
    mutate(key = str_squish(key)) %>%
    spread(key, val) %>%
    dplyr::select(-result) %>%
    janitor::clean_names() %>%
    set_names(c("arq",
                "cargo",
                "contratante_propria_empresa",
                "contratantes",
                "sobre_municipio",
                "dt_divulgacao",
                "dt_inicio",
                "dt_registro",
                "dt_termino",
                "eleicao",
                "empresa_contratada",
                "n_entrevistados",
                "estatistico_responsavel",
                "metodologia_pesquisa",
                "id",
                "pagantes",
                "plano_amostral",
                "estatistico_registro",
                "verificacao",
                "valor")) %>%
    mutate_at(vars(starts_with("dt_")), funs(lubridate::dmy)) %>%
    mutate(n_entrevistados = as.numeric(n_entrevistados),
           valor = parse_number(valor, locale = locale(
               decimal_mark = ",", grouping_mark = "."
           ))) %>%
    mutate(contratantes = rslp:::remove_accents(contratantes)) %>%
    mutate(preco_por_entrevistado = valor / n_entrevistados,
           origem = str_extract(contratantes, re_origem),
           origem = str_remove_all(origem, "[^a-zA-Z ]"),
           origem = str_squish(origem)) %>%
    replace_na(list(origem = "Vazio")) %>%
    mutate(contratante_propria_empresa = if_else(contratante_propria_empresa == "Não", "Não", "Sim")) %>%
    mutate(estatistico_registro = str_extract(estatistico_registro, "[0-9]+")) %>%
    mutate(arq_id = str_extract(arq, "([0-9A-Z_)]+)(?=_)")) %>%
    mutate(criterio_origem = origem == "Recursos proprios" &
               contratante_propria_empresa == "Sim") %>%
    # tudo o que nao bateu é lixo - dado duplicado
    inner_join(select(pesq_main_tidy, -arq), c("id", "arq_id")) %>%
    group_by(estatistico_registro) %>%
    mutate(empresas_por_estatistico = n_distinct(empresa), n = n()) %>%
    ungroup() %>%
    dplyr::mutate(cnpj = stringr::str_extract(empresa_contratada, re_cnpj),
                  emp_nm = clean_emp(empresa_contratada))


# pesq_details_tidy %>%
#     filter(eleicao == "Eleições Municipais Suplementares 2012") %>%
#     select(arq, arq_id, id) %>%
#     # tudo o que nao bateu é lixo - dado duplicado
#     inner_join(select(pesq_main_tidy, -arq), c("arq_id", "id"))
#
# x %>% count(eleicao)
#
# pesq_main_tidy %>% filter(is.na(arq_id))
# x %>% filter(is.na(arq_id))

pesqEle <- pesq_details_tidy %>%
    dplyr::group_by_at(dplyr::vars(-arq, -arq_id, -id)) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup() %>%
    tibble::rowid_to_column("id_seq") %>%
    dplyr::select(
        # informações de identificação
        id_seq,
        id_pesq = id,
        id_muni = arq_id,
        # informações básicas
        info_uf = uf,
        info_muni = muni,
        info_election = eleicao,
        info_position = cargo,
        # informações da empresa
        comp_nm = emp_nm,
        comp_cnpj = cnpj,
        comp_contract_same = contratante_propria_empresa,
        # informações do estatístico responsável
        stat_id = id_stat,
        stat_nm = nm_stat,
        # informações da pesquisa
        pesq_n = n_entrevistados,
        pesq_val = valor,
        pesq_contractors = contratantes,
        pesq_origin = origem,
        # datas
        dt_reg = dt_registro,
        dt_pub = dt_divulgacao,
        dt_start = dt_inicio,
        dt_end = dt_termino,
        # textos
        txt_verif = verificacao,
        txt_method = metodologia_pesquisa,
        txt_about = sobre_municipio,
        txt_plan = plano_amostral
    )
# info muni id
#
pesqEle %>%
    count(info_uf, sort = TRUE)







#-------------------------------------------------------------------------------




ui <- dashboardPage(

    dashboardHeader(title = "vis pesqEle"),

    dashboardSidebar(

        sliderInput("corte_preco", "Corte preço por entrevistado", 0, 100, 5, step = 1),
        sliderInput("corte_empresas", "Corte empresas por Estatístico", 1, 100, 1, step = 1),
        sliderInput("corte_qtd", "Quantidade de pesquisas do estatístico", 1, 2000, 1, step = 10),
        checkboxInput("contrat", "Contratante própria empresa?", FALSE),
        checkboxInput("valor0", "Tirar pesquisas de valor zero?", TRUE)
    ),

    dashboardBody(
        fluidRow(
            valueBoxOutput("qtd", 3)
        ),

        box(DT::dataTableOutput("tabela"), width = 12, height = 2000)

    )

)

server <- function(input, output) {

    bd_final <- reactive({

        da <- pesq_details_tidy %>%
            filter(preco_por_entrevistado <= input$corte_preco,
                   empresas_por_estatistico <= input$corte_empresas,
                   n >= input$corte_qtd)
        if (input$contrat) da <- filter(da, criterio_origem)
        if (input$valor0) da <- filter(da, valor > 0)
        da
    })

    output$qtd <- renderValueBox({
        valueBox(nrow(bd_final()),
                 "Quantidade de pesquisas",
                 icon = icon("fa-signal"))

    })

    output$tabela <- DT::renderDataTable({
        bd_final() %>%
            select(-sobre_municipio, -metodologia_pesquisa,
                   -plano_amostral, -verificacao) %>%
            arrange(preco_por_entrevistado)
    }, options = list(scrollX = TRUE, height = 2000))

}

shinyApp(ui, server)
