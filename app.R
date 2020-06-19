## -----------------------------------------------------------------
## 
## app.R
## 
## This is a wrapper script that defines the libraries, calls other
## scripts that contains app components
## 
##
## -----------------------------------------------------------------



library(shiny)
library(shinydashboard)
# library(shinydashboardPlus)
library(dashboardthemes)
library(civis)
library(ggplot2)
library(dplyr)
library(reshape2)
library(ggthemes)
library(markdown)
library(rgdal)
library(leaflet)


source("styling.R")
source('theme_diy.R')
source('dat-gather.R')
source("myUI.R")
source("myServer.R")


shinyApp(ui = ui, server = server)
