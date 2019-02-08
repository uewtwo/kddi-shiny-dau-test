library(shinydashboard)
library(DT)

header <- dashboardHeader(title = tags$a(
  href = "http://datumstudio.jp/",
  tags$img(src="datum-logo-white.png", width=200))
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("File Manager", tabName = "filemanager", icon = icon("file-medical-alt"),
      menuSubItem("CSV Uploader", tabName = "filemanager-sub-csvuploader", icon = icon("file")),
      menuSubItem("Excel Uploader", tabName = "filemanager-sub-xlsxuploader", icon = icon("file-excel"))
    )
  ),
  textOutput("res")
)

body.dashboard <- fluidRow(
  box(
    title = "Histogram", status = "primary", solidHeader = TRUE,
    collapsible = TRUE,
    plotOutput("dashboard.plot1", height = 250)),
  box(
    title = "Controls", status = "primary", solidHeader = TRUE,
    collapsible = TRUE,
    sliderInput("slider", "Number of observations:", 1, 100, 50)
  )
)

body.filemanager.csvuploader <- fluidRow(
  # file uploader
  # column(12, box(
  box(
    title = "Upload csv file", status = "primary", solidHeader = TRUE,
    collapsible = TRUE,
    width = 4,
    fileInput(
      "toBeUploaded", "Choose file to upload",
      accept = c(
        "text/csv",
        "text/commna-separated-values",
        "text/tab-separated-values",
        "text/plain",
        ".csv",
        ".tsv"
      )
    ),
    numericInput("skipIndex", label = "skip indexes", value = 0, width = "50px"),
    checkboxInput("existHeader", label = "exist header", value = TRUE),
    radioButtons(
      "csvSeparator",
      label = "select csv separator",
      choices = list(
        "commna" = ",", "tab" = "\t", "semicolon" = ";"
      ),
      selected = ","
    ),
    radioButtons(
      "csvQuoter",
      label = "select csv quoter",
      choices = list(
        "single quote" = "'", "double quote" = "\""
      ),
      selected = "\""
    ),
    actionButton(
      "csvValidator",
      label = "Upload",
      icon = icon("file-upload")
    )
  ),
  # Preview 表示用box
  # file commit ボタンで input に渡して，中で読み込んで df にして，テーブルにして output 返す.
  box(
    title = "Preview", status = "primary", solidHeader = TRUE,
    collapsible = TRUE,
    textOutput("csvuploader.message"),
    div(style = 'overflow-x: scroll', DT::dataTableOutput("csvuploader.preview"))
    # tableOutput("csvuploader.preview")
  )
)

shinyUI(dashboardPage(skin = "green",
  header,
  sidebar,
  dashboardBody(
    tabItems(
      tabItem("dashboard", body.dashboard),
      tabItem("filemanager-sub-csvuploader", body.filemanager.csvuploader),
      tabItem("filemanager-sub-xlsxuploader", "Want to upload xlsx!!")
    )
  )
))
