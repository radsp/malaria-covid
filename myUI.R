# library(shinydashboardPlus)
# library(ggplot2)
# source('theme_diy.R')

# library(shinydashboard)

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
}



ui <- navbarPage( theme = "bootstrap.min.css", 
                  
                  title = "Malaria During COVID-19",
                  
                  
                  
                  tabPanel("Info",
                           dashboardPagePlus(
                             dashboardHeaderPlus(disable = T),
                             
                             dashboardSidebar(sidebarMenu(id = "menuInfo",
                                                           menuItem("Getting Started", icon = NULL, tabName = "tabInfoStart"),
                                                           menuItem("Malaria Data", icon = NULL, tabName = "tabInfoMal"),
                                                           menuItem("COVID-19 Data", icon = NULL, tabName = "tabInfoCovid"),
                                                           menuItem("Methods", icon = NULL, tabName = "tabInfoMethods"))),
                             dashboardBody(theme_grey_light_edited,
                                           
                                           tabItems(
                                             tabItem(tabName = "tabInfoStart" #,
                                                     ## ----------------------------------------------------------------------------------!
                                                     ## NOTES: including the html file messes up the other tabs (graphs not showing up    !
                                                     ## in the malaria and covid tabs. Including the markdown file resolves this issue    !
                                                     ## but the title in the markdown is not showing in the dashboard)                    !
                                                     ## ----------------------------------------------------------------------------------!
                                                     # includeMarkdown("getting-started.rmd")
                                                    ),
                                             tabItem(tabName = "tabInfoMal" #, 
                                                     # includeMarkdown("malaria-data.rmd")
                                                    ),
                                             tabItem(tabName = "tabInfoCovid"# ,
                                                     # includeMarkdown("covid-data.rmd")
                                                    ),
                                             tabItem(tabName = "tabInfoMethods"#,
                                                     # includeMarkdown("methods.rmd")
                                                    )
                                           )
                                           
                                           )
                             
                           ),
                           
                           mainPanel()
                           ),
                           
                          
                  
                  tabPanel("Malaria",
                           
                            tags$style(type = "text/css", "#plot1 {height: calc(100vh - 150px) !important; }"),
                            tags$style(type = "text/css", "#plot2 {height: calc(100vh - 150px) !important; }"),

                           dashboardPagePlus(
                             
                             dashboardHeaderPlus(disable = F, title = NULL),
                             
                             dashboardSidebar(sidebarMenu(id = "menuMalaria", selected = TRUE,
                                                          
                                                convertMenuItem(menuItem("National", id = "menuNational", tabName = "tabMalariaAdm0",
                                                                   icon = NULL, selected = TRUE,
                                                                   radioButtons(inputId = "inAdm0", label = "Plot by:",
                                                                                choices = c("Country", "Indicator"),
                                                                                selected = "Country", inline = TRUE),
                                                                   uiOutput("outAdm0PlotBy")
                                                                   ), tabName = "tabMalariaAdm0"),
                                                                   
                                                  convertMenuItem(menuItem("Sub-National", id = "menuSubNational", tabName = "tabMalariaAdm1",
                                                                   icon = NULL, selected = FALSE,
                                                                   selectInput(inputId = "inAdm1Ctry", label = "Select Country",
                                                                               choices = sort(unique(xctry$country))),
                                                                   radioButtons(inputId = "inAdm1", label = "Plot by:",
                                                                                choices = c("Admin. Level 1", "Indicator"),
                                                                                selected = NULL, inline = TRUE),
                                                                   uiOutput("outAdm1PlotBy")), tabName = "tabMalariaAdm1")
                                                          # )
                                                          )
                             ),
                             
                             dashboardBody(theme_grey_light_edited,
                                           
                                           tabItems(
                                             tabItem(tabName = "tabMalariaAdm0",
                                                     plotlyOutput("plot1")),
                                             tabItem(tabName = "tabMalariaAdm1",
                                                     plotOutput("plot2"))
                                           )
                                           
                               # plotOutput("plot1"))
                               
                             )),
                           mainPanel( )
                           
                           
                  ),
                  
                  tabPanel("COVID-19",
                           
                             
                           selectInput(inputId = "inCovidCtry", label = "Select Country",
                                       # choices = sort(unique(xctry$country))
                                       choices = "Benin"
                                       ),
                           
                           hr(),
                           
                           fluidRow(
                             column(9, 
                                    box( title = "Areas At Risk for COVID-19 Based On Selected Indicators",
                                         collapsible = TRUE,
                                         leafletOutput("mapCovid"),
                                         width = 12
                                         )),
                             column(3, 
                                    checkboxGroupInput("inRiskIndicator", "Select indicators to be included:",
                                                       c("Elderly Population ( > 60 years old)", "Population density",
                                                         "Mobility", "Community health worker per population", 
                                                         "Handwashing", "........"))
                                    )),
                           
                           
                           h1("Indicators"),
                           
                           fluidRow(
                             
                             box(
                               title = "Elderly Population",
                               collapsible = TRUE,
                               leafletOutput("mapElderly")
                             ),
                             
                             box(
                               title = "Population Density",
                               collapsible = TRUE,
                               leafletOutput("mapPopDen")
                             ),
                             
                             box(
                               title = "Mobility",
                               collapsible = TRUE,
                               leafletOutput("mapMobility")
                             ),
                             
                             box(
                               title = "Community Health Worker",
                               collapsible = TRUE,
                               leafletOutput("mapCHW")
                             ),
                             
                             box(
                               title = "Malaria incidence (annual)",
                               collapsible = TRUE,
                               leafletOutput("mapMalInc")
                             )
                             
                           )
                           
                           
                           
                           ),
                  tags$style(type = 'text/css', 
                             
                             
                             '.navbar-default .navbar-brand {
                             font-weight: bold;
                             color: #000000;
                           }'
                             
                  )
)
  
  
  
  
  # fillPage(
  #   tags$style(type = "text/css", "#plot1 {height: calc(100vh - 80px) !important;}"),
  #   plotOutput("plot1", width = "100%",height = "100%")
  
 
