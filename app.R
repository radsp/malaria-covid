## -----------------------------------------------------------------
## 
## app.R
## 
## This is a wrapper script that defines the libraries, calls other
## scripts that contains app components
## 
##
## -----------------------------------------------------------------


## -----------------------------------------------------------------
# Load packages
## -----------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(civis)
library(ggplot2)
library(dplyr)
library(reshape2)
library(markdown)
library(rgdal)
library(leaflet)

# Packages that are not in the platform

if(!require(shinydashboardPlus)){
  install.packages("shinydashboardPlus")
}

if(!require(dashboardthemes)){
  install.packages("dashboardthemes")
}

if(!require(ggthemes)){
  install.packages("ggthemes")
}

library(shinydashboardPlus)
library(dashboardthemes)
library(ggthemes)

## -----------------------------------------------------------------
# Sources
## -----------------------------------------------------------------

source("styling.R")
source('theme_diy.R')
source('dat-gather.R')
source("myUI.R")
source("myServer.R")


## -----------------------------------------------------------------
# Call the app
## -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
