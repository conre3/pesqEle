form_tse_estado <- function(estado = 'SP', vs, dt, pesquisa = "5") {
  list('javax.faces.partial.ajax'='true',
       'javax.faces.source'='formPesquisa:filtroUf',
       'javax.faces.partial.execute'='formPesquisa:filtroUf',
       'javax.faces.partial.render'='formPesquisa:filtroUf formPesquisa:selectCidades',
       'javax.faces.behavior.event'='change',
       'javax.faces.partial.event'='change',
       'formPesquisa'='formPesquisa',
       'formPesquisa:j_idt49'='',
       'formPesquisa:j_idt51'='',
       'formPesquisa:filtroUf_focus'='',
       'formPesquisa:filtroUf_input'=estado,
       'formPesquisa:eleicoes_focus'='',
       'formPesquisa:eleicoes_input'=pesquisa,
       'formPesquisa:j_idt63_input'=dt[1],
       'formPesquisa:j_idt65_input'=dt[2],
       'javax.faces.ViewState'=vs)
}

form_tse_uf_2018 <- function(estado = 'SP', vs, dt, pesquisa = "5") {
  list('javax.faces.partial.ajax'='true',
       'javax.faces.source'='formPesquisa:idBtnPesquisar',
       'javax.faces.partial.execute'='@all',
       'javax.faces.partial.render'='formPesquisa formPesquisa:grupoPrincipal',
       'formPesquisa:idBtnPesquisar'='formPesquisa:idBtnPesquisar',
       'formPesquisa'='formPesquisa',
       'formPesquisa:j_idt49'='',
       'formPesquisa:j_idt51'='',
       'formPesquisa:filtroUf_focus'='',
       'formPesquisa:filtroUf_input'=estado,
       'formPesquisa:selectCidades_focus'='',
       'formPesquisa:selectCidades_input'='',
       'formPesquisa:eleicoes_focus'='',
       'formPesquisa:eleicoes_input'=pesquisa,
       'formPesquisa:j_idt63_input'=dt[1],
       'formPesquisa:j_idt65_input'=dt[2],
       'javax.faces.ViewState'=vs)
}

form_tse_uf_2020 <- function(estado = 'SP', vs, dt, pesquisa = "5") {
  list('javax.faces.partial.ajax'='true',
       'javax.faces.source'='formPesquisa:idBtnPesquisar',
       'javax.faces.partial.execute'='@all',
       'javax.faces.partial.render'='formPesquisa formPesquisa:grupoPrincipal',
       'formPesquisa:idBtnPesquisar'='formPesquisa:idBtnPesquisar',
       'formPesquisa'='formPesquisa',
       'formPesquisa:j_idt49'='',
       'formPesquisa:j_idt51'='',
       'formPesquisa:filtroUf_focus'='',
       'formPesquisa:filtroUf_input'=estado,
       'formPesquisa:selectCidades_focus'='',
       'formPesquisa:selectCidades_input'='',
       'formPesquisa:eleicoes_focus'='',
       'formPesquisa:eleicoes_input'=pesquisa,
       'formPesquisa:j_idt63_input'=dt[1],
       'formPesquisa:j_idt65_input'=dt[2],
       'javax.faces.ViewState'=vs)
}


form_tse_muni <- function(uf, muni, vs) {
  list('javax.faces.partial.ajax'='true',
       'javax.faces.source'='formPesquisa:idBtnPesquisar',
       'javax.faces.partial.execute'='@all',
       'javax.faces.partial.render'='formPesquisa formPesquisa:grupoPrincipal',
       'formPesquisa:idBtnPesquisar'='formPesquisa:idBtnPesquisar',
       'formPesquisa'='formPesquisa',
       'formPesquisa:j_idt49'='',
       'formPesquisa:j_idt51'='',
       'formPesquisa:j_idt53_focus'='',
       'formPesquisa:j_idt53_input'=uf,
       'formPesquisa:selectCidades_focus'='',
       'formPesquisa:selectCidades_input'=muni,
       'formPesquisa:eleicoes_focus'='',
       'formPesquisa:eleicoes_input'='[selecione]',
       'formPesquisa:j_idt64_input'='',
       'formPesquisa:j_idt66_input'='',
       'javax.faces.ViewState'=vs)
}

form_detalhar <- function(item, uf = "", muni = "", vs, dt = "") {
  l <- list('javax.faces.partial.ajax'='true',
       'javax.faces.source'=sprintf('formPesquisa:tabelaPesquisas:%d:detalhar', item),
       'javax.faces.partial.execute'='@all',
       'formPesquisa:tabelaPesquisas:%d:detalhar'=sprintf('formPesquisa:tabelaPesquisas:%d:detalhar', item),
       'formPesquisa'='formPesquisa',
       'formPesquisa:j_idt49'='',
       'formPesquisa:j_idt51'='',
       'formPesquisa:j_idt53_focus'='',
       'formPesquisa:j_idt53_input'=uf,
       'formPesquisa:selectCidades_focus'='',
       'formPesquisa:selectCidades_input'=muni,
       'formPesquisa:eleicoes_focus'='',
       'formPesquisa:eleicoes_input'='[selecione]',
       'formPesquisa:j_idt64_input'='',
       'formPesquisa:j_idt66_input'='',
       "formPesquisa:j_idt63_input"=dt[1],
       "formPesquisa:j_idt65_input"=dt[2],
       'javax.faces.ViewState'=vs)
  names(l) <- sprintf(names(l), item)
  l
}

form_tse_date <- function(date, vs, uf = "") {
  dt <- format(as.Date(date), "%d/%m/%Y")
  list('javax.faces.partial.ajax' = 'true',
       'javax.faces.source' = 'formPesquisa:idBtnPesquisar',
       'javax.faces.partial.execute' = '@all',
       'javax.faces.partial.render' = 'formPesquisa formPesquisa:grupoPrincipal',
       'formPesquisa:idBtnPesquisar' = 'formPesquisa:idBtnPesquisar',
       'formPesquisa:filtroUf_input' = uf,
       'formPesquisa' = 'formPesquisa',
       'formPesquisa:j_idt63_input' = dt,
       'formPesquisa:j_idt65_input' = dt,
       'javax.faces.ViewState' = vs)
}

form_detalhar_date <- function(item, date, vs, uf = "") {
  dt <- format(as.Date(date), "%d/%m/%Y")
  l <- list('javax.faces.partial.ajax' = 'true',
            'javax.faces.source' = sprintf('formPesquisa:tabelaPesquisas:%d:detalhar', item),
            'javax.faces.partial.execute' = '@all',
            'formPesquisa:tabelaPesquisas:%d:detalhar' = sprintf('formPesquisa:tabelaPesquisas:%d:detalhar', item),
            'formPesquisa' = 'formPesquisa',
            'formPesquisa:filtroUf_input' = uf,
            'formPesquisa:j_idt64_input' = dt,
            'formPesquisa:j_idt66_input' = dt,
            'javax.faces.ViewState'=vs)
  names(l) <- sprintf(names(l), as.integer(item))
  l
}

