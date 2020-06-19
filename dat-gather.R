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
xctry0 <- read_civis("covid.appdata_ctry")
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
                                                       "Malaria Deaths", "ANC Visit")))

xctryExc <- xctryExc0 %>%
  mutate(colourgroup = factor(colourgroup, 
                              levels = c("All Cause Consultation", "Malaria Confirmed Cases", 
                                         "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                         "Malaria Deaths", "ANC Visit")))

xprov <- xprov0 %>% 
  mutate(colourgroup = factor(colourgroup, levels = c("allcause", "confirmed", "tpr", 
                                                     "severe", "deaths", "anc1_visit", "covid")),
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


