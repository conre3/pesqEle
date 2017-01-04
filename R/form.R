form_tse_estado <- function(estado = 'SP', vs) {
  list('javax.faces.partial.ajax'='true',
       'javax.faces.source'='formPesquisa:j_idt53',
       'javax.faces.partial.execute'='formPesquisa:j_idt53',
       'javax.faces.partial.render'='formPesquisa:selectCidades',
       'javax.faces.behavior.event'='change',
       'javax.faces.partial.event'='change',
       'formPesquisa'='formPesquisa',
       'formPesquisa:j_idt49'='',
       'formPesquisa:j_idt51'='',
       'formPesquisa:j_idt53_focus'='',
       'formPesquisa:j_idt53_input'=estado,
       'formPesquisa:selectCidades_focus'='',
       'formPesquisa:selectCidades_input'='',
       'formPesquisa:eleicoes_focus'='',
       'formPesquisa:eleicoes_input'='[selecione]',
       'formPesquisa:j_idt64_input'='',
       'formPesquisa:j_idt66_input'='',
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

form_detalhar <- function(item, uf, muni, vs) {
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
       'javax.faces.ViewState'=vs)
  names(l) <- sprintf(names(l), item)
  l
}
