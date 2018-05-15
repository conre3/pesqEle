
# Modules -----------------------------------------------------------------

source("modules/estatisticos/tableStat.R")
source("modules/estatisticos/selectStat.R")
source("modules/estatisticos/statCounts.R")

# Module UI ---------------------------------------------------------------

estatisticosUI <- function(id) {
  ns <- NS(id)
  
  tabItem(
    tabName = id,
    fluidRow(
      tabBox(
        width = 12,
        height = 470,
        tabPanel(
          title = "Geral",
          tableStatOutput(ns("table_stat")),
          tags$hr(),
          tags$p("* Valor mediano cobrado por pesquisa."),
          tags$p("** Custo mediano por unidade amostral.")  
        ),
        tabPanel(
          title = "Por estatístico",
          selectStatInput(ns("stat_select")),
          column(
            style = "background-color: #ededed",
            width = 9,
            tags$br(),
            tags$br(),
            tags$br(),
            tags$br()
          ),
          column(
            width = 3,
            statCountsOutput(ns("stat_counts"))
          )
        )
      )
    )
  )
  
}


# Module server -----------------------------------------------------------

estatisticos <- function(input, output, session, df_pesq) {
  
  callModule(
    module = tableStat,
    id = "table_stat",
    df_pesq = df_pesq
  )
  
  df_pesq_stat <- callModule(
    module = selectStat,
    id = "stat_select",
    df_pesq = df_pesq
  )
  
  callModule(
    module = statCounts,
    id = "stat_counts",
    df_pesq = df_pesq_stat
  )
    
}
