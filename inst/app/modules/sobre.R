
# Module UI ---------------------------------------------------------------

sobreUI <- function(id) {
  
  ns <- NS(id)
  
  
  tabItem(
    tabName = id,
    fluidRow(
      box(
        title = "Sobre o aplicativo",
        width = 12,
        tags$p("Este aplicativo tem como objetivo divulgar informações das
               pesquisas eleitorais de 2018. Por lei, toda pesquisa eleitoral
               deve ter um estatístico responsável registrado no Conselho
               Regional de Estatística Pesquisas com custos muito baixos ou
               estatísticos responsáveis por muitas pesquisas em pouco tempo
               podem ser indícios de fraude."
        )
      ),
      column(width = 1),
      box(
        title = "Responsáveis",
        width = 10,
        column(
          width = 3,
          img(src = "trecenti.jpg", width = 170, height = 160)
        ),
        column(
          width = 3,
          br(),
          tags$p(tags$strong("Julio Trecenti")),
          tags$p("Presidente do CONRE-3ª região"),
          tags$p("Sócio-fundador da Curso-R"),
          tags$p("Doutorando em Estatística")
        ),
        column(
          width = 3,
          img(src = "amorim.jpg", width = 170, height = 160)
        ),
        column(
          width = 3,
          br(),
          tags$p(tags$strong("William Amorim")),
          tags$p("Sócio-fundador da Curso-R"),
          tags$p("Doutorando em Estatística")
        )
      ),
      column(width = 2),
      box(
        title = "Apoio",
        width = 8,
        column(
          width = 6,
          tags$a(
            tags$img(src = "conre3.jpg", width = 300, height = 80),
            href = "http://conre3.org.br/"
          )
        ),
        column(
          width = 6,
          tags$a(
            tags$img(src = "cursor.jpg", width = 80, height = 80, align = "center"),
            href = "http://curso-r.com"
          )
        )
      )
    )
    
  )
  
}

# Module server -----------------------------------------------------------


