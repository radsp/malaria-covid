## -----------------------------------------------------------------
## 
## dat-gather.R
## 
## This script load all data for the app and perform (minimal) processing
## on the dataset
##
## -----------------------------------------------------------------



## Not run - for local development
# load("data/x4app_ctry.RData")
# load("data/x4app_prov.RData")


# National data
# xctry0 <- read_civis("covid.appdata_ctry")
xctry0 <- read_civis("covid.appdata_ctry_hqdemoField")
# National data for plotting excess as ribbon/shaded
xctryExc0 <- read_civis("covid.appdata_ctry_excess")

# Provincial data
xprov0 <- read_civis("covid.appdata_prov")
xprovExc0 <- read_civis("covid.appdata_prov_excess")



# Enforce the factor level again so the color/linetype matches

xctry <- mutate(xctry0,
                colourgroup = factor(colourgroup, 
                                     levels = c("allcause", "confirmed", "tpr", 
                                                "severe", "deaths", "anc1_visit", "covid")),
                boxgroup = factor(boxgroup, levels = c("All Cause Consultation", "Malaria Confirmed Cases", 
                                                       "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                                       "Malaria Deaths", "ANC Visit"))) %>%
  mutate(line_label = if_else( (linegroup %in% "Long-term mean"), "Long-term mean",
                               if_else(!(variable %in% "covid_projection") , as.character(year), 
                                       paste("COVID-19 ", pointgroup, sep = ""))),
         point_label = paste(if_else( variable %in% "covid_projection", "COVID-19 ", ""), pointgroup, sep = "")) %>%
  filter(!(country %in% c("Tanzania (Mainland)")))
                                           

xctryExc <- xctryExc0 %>%
  mutate(date = as.Date(as.character(date)),
         colourgroup = factor(colourgroup, 
                              levels = c("All Cause Consultation", "Malaria Confirmed Cases", 
                                         "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                         "Malaria Deaths", "ANC Visit"))) %>%
  filter( (date <= as.Date("2020-03-01")) & (date >= as.Date("2020-01-01"))   &  !(country %in% "Tanzania (Mainland)") )
    

xprov <- xprov0 %>% 
  mutate(colourgroup = factor(colourgroup, levels = c("allcause", "confirmed", "tpr", 
                                                      "severe", "deaths", "anc1_visit", "covid"),
                              labels = c("All Cause Consultation", "Malaria Confirmed Cases", 
                                         "Malaria Test Positivity Rate", "Severe Malaria Cases", "Malaria Deaths", 
                                         "ANC Visit", "COVID-19")),
         boxgroup = factor(boxgroup, levels = c("All Cause Consultation", "Malaria Confirmed Cases", 
                                                "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                                "Malaria Deaths", "ANC Visit")),
         alphagroup = factor(alphagroup, levels = c("2020", "Other Years")),
         linegroup = factor(linegroup, levels = c( "Long-term mean", "Monthly Data/Forecast")),
         pointgroup = factor(pointgroup, levels = c("Forecast", "Observed")))

xprovExc <- xprovExc0 %>%
  mutate(colourgroup = factor(colourgroup, 
                              levels = c("All Cause Consultation", "Malaria Confirmed Cases", 
                                         "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                         "Malaria Deaths", "ANC Visit")))



# COVID Risk Map ---------------------------------------------------------------

s <- readOGR("data/Benin Trimmed/Population_Layer.shp")


