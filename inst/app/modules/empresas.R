# Modules -----------------------------------------------------------------

source("modules/empresas/tableEmp.R")
source("modules/empresas/selectEmp.R")
source("modules/empresas/selectEmpPesq.R")
source("modules/empresas/countsEmp.R")
source("modules/empresas/summaryEmp.R")

# Module UI ---------------------------------------------------------------

empresasUI <- function(id, df_pesq = df_pesq) {
  ns <- NS(id)
  
  tabItem(
    tabName = id,
    fluidRow(
      tabBox(
        width = 12,
        height = 470,
        tabPanel(
          title = "Geral",
          tableEmpOutput(ns("table_emp")),
          tags$hr(),
          tags$p("* Valor mediano cobrado por pesquisa."),
          tags$p("** Custo mediano por unidade amostral.")  
        ),
        tabPanel(
          title = "Por empresa",
          column(
            width = 12,
            selectEmpInput(ns("emp_select"), df_pesq = df_pesq)
          ),
          column(
            style = "background-color: #ededed",
            width = 9,
            selectEmpPesqInput(ns("emp_pesq_select"), df_pesq = df_pesq),
            tags$div(
              style = "font-size = 11pt",
              pesqSummaryOutput(ns("pesq_summary")),
              tags$br()
            )
          ),
          column(
            width = 3,
            countsEmpOutput(ns("emp_counts"))
          )
        )
      )
    )
  )
  
}


# Module server -----------------------------------------------------------

empresas <- function(input, output, session, df_pesq) {
  
  callModule(
    module = tableEmp,
    id = "table_emp",
    df_pesq = df_pesq
  )
  
  df_pesq_emp <- callModule(
    module = selectEmp,
    id = "emp_select",
    df_pesq = df_pesq
  )
  
  callModule(
    module = countsEmp,
    id = "emp_counts",
    df_pesq = df_pesq_emp
  )
  
  df_pesq_emp_pesqid <- callModule(
    module = selectEmpPesq,
    id = "emp_pesq_select",
    df_pesq = df_pesq_emp
  )
  
  callModule(
    module = pesqSummary,
    id = "pesq_summary",
    df_pesq = df_pesq_emp_pesqid
  )
    
}
