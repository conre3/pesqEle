clean_stat_nm <- function(x) {
  x %>%
    remove_accents() %>% 
    stringr::str_to_upper() %>% 
    stringr::str_remove_all("[^A-Z0-9 .-]") %>%
    stringr::str_replace_all(" DE | DOS | DA | DAS | DO ", " ") %>%
    stringr::str_squish()
}
clean_stat_id <- function(x) {
  x %>%
    stringr::str_extract("[0-9]{3,}")
}
id_fonema <- function(stat_id, stat_nm) {
  stat_nm <- clean_stat_nm(stat_nm)
  stat_id <- clean_stat_id(stat_id)
  fonema <- SoundexBR::soundexBR(stat_nm)
  stringr::str_glue("{stat_id}_{fonema}")
}
clean_emp <- function(x) {
  re <- "(?<=CNPJ:\\s{1,5}[0-9]{14}\\s{1,3}-)((.|\n)+)"
  x %>%
    stringr::str_extract(re) %>%
    stringr::str_squish() %>%
    stringr::str_to_upper()
}

pesq_tidy <- function(pesq_main, pesq_details) {
  re_abrang <- paste0("(?<!Vila |Jardim |Assis |Jd\\. )",
                         "[bB]rasil[. ](?!Novo)|",
                         "(?<!Porto |Funda\u00e7\u00e3o )[Nn]acional")

  re_origem <- "(?<=Origem do Recurso: )([a-zA-Z()\\s]+)"
  re_cnpj <- "(?<=CNPJ:\\s{1,5})([0-9]+)"
  
  pesq_main_tidy <- pesq_main %>%
    dplyr::filter(numero_de_identificacao != 'Nenhum registro encontrado!') %>%
    purrr::set_names(c('arq', 'id', 'empresa', 
                       'stat_id', 'stat_nm',
                       'dt_reg', 'abrangencia', 'acoes')) %>%
    dplyr::select(-acoes)
  
  pesq_details_tidy <- pesq_details %>%
    dplyr::mutate(key = stringr::str_squish(key)) %>%
    tidyr::spread(key, val) %>%
    dplyr::select(-result) %>%
    purrr::set_names(c("arq",
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
    # dplyr::filter(eleicao == "Elei\u00e7\u00f5es Gerais 2018") %>%
    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("dt_")),
                     dplyr::funs(as.Date(., format = "%d/%m/%Y"))) %>%
    dplyr::mutate(n_entrevistados = as.numeric(n_entrevistados),
                  valor = parse_reais(valor)) %>%
    dplyr::mutate(contratantes = remove_accents(contratantes)) %>%
    dplyr::mutate(preco_por_entrevistado = valor / n_entrevistados,
           origem = stringr::str_extract(contratantes, re_origem),
           origem = stringr::str_remove_all(origem, "[^a-zA-Z ]"),
           origem = stringr::str_squish(origem)) %>%
    tidyr::replace_na(list(origem = "Vazio")) %>%
    dplyr::mutate(contratante_propria_empresa = dplyr::if_else(
      contratante_propria_empresa == "N\u00e3o", "N\u00e3o", "Sim")) %>%
    dplyr::mutate(estatistico_registro = stringr::str_extract(estatistico_registro, "[0-9]+")) %>%
    dplyr::mutate(arq_id = stringr::str_extract(arq, "([0-9A-Z_)]+)(?=_)")) %>%
    dplyr::mutate(criterio_origem = origem == "Recursos proprios" &
             contratante_propria_empresa == "Sim") %>%
    # tudo o que nao bateu \\u00e9 lixo - dado duplicado
    dplyr::inner_join(dplyr::select(pesq_main_tidy, -arq), c("id")) %>%
    dplyr::group_by(estatistico_registro) %>%
    dplyr::mutate(empresas_por_estatistico = dplyr::n_distinct(empresa), n = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(cnpj = stringr::str_extract(empresa_contratada, re_cnpj),
           emp_nm = clean_emp(empresa_contratada)) %>%
    # pq isso aqui estava sendo feito?
    dplyr::group_by_at(dplyr::vars(-arq, -arq_id, -id)) %>%
    dplyr::slice(1) %>%
    dplyr::ungroup()
  
  pesqEle2018 <- pesq_details_tidy %>%
    tibble::rowid_to_column("id_seq") %>%
    dplyr::select(
      # informa\\u00e7\\u00f5es de identifica\\u00e7\\u00e3o
      id_seq,
      id_pesq = id,
      # id_muni = arq_id,
      # informa\\u00e7\\u00f5es b\\u00e1sicas
      # info_uf = uf,
      # info_muni = muni,
      info_election = eleicao,
      info_position = cargo,
      # informa\\u00e7\\u00f5es da empresa
      comp_nm = emp_nm,
      comp_cnpj = cnpj,
      comp_contract_same = contratante_propria_empresa,
      # informa\\u00e7\\u00f5es do estat\\u00edstico respons\\u00e1vel
      stat_id = stat_id,
      stat_nm = stat_nm,
      # informa\\u00e7\\u00f5es da pesquisa
      pesq_n = n_entrevistados,
      pesq_val = valor,
      pesq_contractors = contratantes,
      pesq_origin = origem,
      pesq_same = criterio_origem,
      # datas
      dt_reg = dt_registro,
      dt_pub = dt_divulgacao,
      dt_start = dt_inicio,
      dt_end = dt_termino,
      # textos (nao serao usados)
      txt_verif = verificacao,
      txt_method = metodologia_pesquisa,
      txt_about = sobre_municipio,
      txt_plan = plano_amostral
    ) %>%
    # dplyr::filter(info_election == "Elei\u00e7\u00f5es Gerais 2018") %>%
    tidyr::separate(id_pesq, c("info_uf", "temp"), "-", remove = FALSE) %>%
    dplyr::select(-temp) %>%
    dplyr::mutate(stat_unique = id_fonema(stat_id, stat_nm)) %>% 
    dplyr::group_by(stat_unique) %>% 
    dplyr::mutate(stat_nm = clean_stat_nm(dplyr::first(stat_nm))) %>% 
    dplyr::mutate(pesq_range = ifelse(stringr::str_detect(txt_about, re_abrang), "Nacional", "Outros")) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(stat_nm = dplyr::if_else(
      stat_nm == "7655", "AUGUSTO SILVA ROCHA", stat_nm))
  pesqEle2018
}
