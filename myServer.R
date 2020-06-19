server <- function(input, output, session){
  
  output$outAdm0PlotBy <- renderUI({
    
    switch(input$inAdm0,
           
           "Country" = selectInput(inputId = "inAdm0Ctry", label = NULL,
                                   choices = sort(unique(xctry$country))),
           "Indicator" = selectInput(inputId = "inAdm0Indi", label = NULL,
                                     choices = c("All Cause Consultation", "Malaria Confirmed Cases",
                                                 "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                                 "Malaria Deaths", "ANC Visit"),
                                     selected = NULL)
           
           )
    
  })
  
  
  output$outAdm1PlotBy <- renderUI({
    
    switch(input$inAdm1, 
           
           "Admin. Level 1" = selectInput(inputId = "inAdm1Prov", label = NULL,
                                          choices = sort(unique(xprov$admin_level_1[xprov$country %in% input$inAdm1Ctry]))),
           "Indicator" = selectInput(inputId = "inAdm1Indi", label = NULL,
                                     choices = c("All Cause Consultation", "Malaria Confirmed Cases",
                                                 "Malaria Test Positivity Rate", "Severe Malaria Cases",
                                                 "Malaria Deaths", "ANC Visit"),
                                     selected = NULL)
           
           )
  })
  
  
  
  # Get data for country level
  get_datAdm0 <- reactive({
    
    if(input$inAdm0 %in% "Country"){
      a <- subset(xctry, country %in% input$inAdm0Ctry)
      b <- subset(xctryExc, country %in% input$inAdm0Ctry )
    } else if(input$inAdm0 %in% "Indicator") {
      a <- subset(xctry, boxgroup %in% input$inAdm0Indi)
      b <- subset(xctryExc, boxgroup %in% input$inAdm0Indi)
    }
    
    return(list(dat = a, ribbon = b))
  })
  
  
  # Get data for provincial level
  get_datAdm1 <- reactive({
    
    if(input$inAdm1 %in% "Admin. Level 1"){
      a <- xprov %>% filter( (country %in% input$inAdm1Ctry) & (admin_level_1 %in% input$inAdm1Prov) )
      b <- xprovExc %>% filter( (country %in% input$inAdm1Ctry) & (admin_level_1 %in% input$inAdm1Prov) )
    } else if(input$inAdm1 %in% "Indicator"){
      a <- xprov %>% filter( (country %in% input$inAdm1Ctry) & (boxgroup %in% input$inAdm1Indi)  )
      b <- xprovExc %>% filter( (country %in% input$inAdm1Ctry) & (boxgroup %in% input$inAdm1Indi)  )
    }
    
    return(list(dat = a, ribbon = b))
    
  })
  

  
  # National level plot -------------------------------------------------------------------------
  
  output$plot1 <- renderPlot({
    
    dAdm0 <- get_datAdm0()
    
    if(input$inAdm0 == "Country"){
      
      g1 <- ggplot(dAdm0[["dat"]], aes(x = month)) +
        geom_line(aes(x = month, y = value, colour = colourgroup, 
                      linetype = linegroup, alpha = alphagroup, group = interaction(mygroup, alphagroup, linegroup, colourgroup)), size = 0.9) +
        geom_point(aes(x = month, y = value_point, colour = colourgroup,
                       shape = pointgroup), size = 3) +
        geom_ribbon(data = dAdm0$ribbon, 
                    aes(x = month, ymin = minval, ymax = maxval, fill = colourgroup), colour = NA, alpha = 0.1) +
        facet_wrap( ~ boxgroup, scales = "free") +
        xlab("") + 
        ylab("Cases per 1K people") +
        ggtitle(dAdm0$dat$country[1]) +
        scale_x_continuous(breaks = seq(from = 1, to = 12, by = 2), labels = month.abb[seq(from = 1, to = 12, by = 2)]) +
        # theme_few(20) +
        scale_alpha_manual("", values = c(1, 0.3), drop = FALSE) +
        scale_linetype_manual("", values = c("dotted", "solid"), labels = c("Long-term mean", "2020"), drop = FALSE) +
        scale_shape_manual(values = c(1, 16), drop = FALSE) +
        scale_colour_manual("", values = clrset, 
                            labels = c("", "", "", "", "", "", "Covid"), drop = FALSE) +
        scale_fill_manual(values = clrset, drop = FALSE) +
        guides(fill = FALSE,
               colour = guide_legend(override.aes = list(colour = c(NA, NA, NA, NA, NA, NA, "#a65628"),
                                     shape = NA), order = 1)) +
        theme(legend.title = element_blank())
      
      
      
    } else if(input$inAdm0 == "Indicator"){
      
      g1 <- ggplot(dAdm0$dat) +
        geom_line(aes(x = month, y = value, colour = colourgroup,
                      linetype = linegroup, alpha = alphagroup, group = interaction(mygroup, alphagroup, linegroup, colourgroup))) +
        geom_point(aes(x = month, y = value_point, colour = colourgroup,
                       shape = pointgroup), size = 2) +
        geom_ribbon(data = dAdm0$ribbon, 
                    aes(x = month, ymin = minval, ymax = maxval, fill = colourgroup), colour = NA, alpha = 0.1) +
        facet_wrap(~ country, scales = "free") +
        xlab("") + 
        ylab("Cases per 1K people") +
        ggtitle(input$inAdm0Indi) +
        scale_x_continuous(breaks = seq(from = 1, to = 12, by = 2), labels = month.abb[seq(from = 1, to = 12, by = 2)]) +
        # theme_few(16)  +
        scale_alpha_manual("", values = c(1, 0.3), drop = FALSE) +
        scale_linetype_manual("", values = c("dotted", "solid"), labels = c("Long-term mean", "2020"), drop = FALSE) +
        scale_shape_manual(values = c(1, 16), drop = FALSE) +
        scale_colour_manual("", values = clrset, labels = c("", "", "", "", "", "", "Covid"), drop = FALSE) +
        scale_fill_manual(values = clrset, drop = FALSE) +
        guides(fill = FALSE,
               colour = guide_legend(
               override.aes = list(colour = c(NA, NA, NA, NA, NA, NA, "#a65628"),
                                      shape = NA), order = 1)) +
        theme(legend.title = element_blank())
    }
    
    print(g1)

  })
  
  
  
  ## Provincial plot ----------------------------------------------------------
  
  output$plot2 <- renderPlot({
    
    dAdm1 <- get_datAdm1()
    
    if(input$inAdm1 == "Admin. Level 1"){
      
      g2 <- ggplot(dAdm1$dat, aes(x = month)) +
        geom_line(aes(x = month, y = value, colour = colourgroup, 
                      linetype = linegroup, alpha = alphagroup, group = interaction(mygroup, alphagroup, linegroup, colourgroup)), size = 0.9) +
        geom_point(aes(x = month, y = value_point, colour = colourgroup,
                       shape = pointgroup), size = 3) +
        geom_ribbon(data = dAdm1$ribbon, 
                    aes(x = month, ymin = minval, ymax = maxval, fill = colourgroup), colour = NA, alpha = 0.1) +
        facet_wrap( ~ boxgroup, scales = "free") +
        xlab("") + 
        ylab("Cases per 1K people") +
        ggtitle(paste(dAdm1$dat$country[1], dAdm1$dat$admin_level_1[1], sep = " - ")) +
        scale_x_continuous(breaks = seq(from = 1, to = 12, by = 2), labels = month.abb[seq(from = 1, to = 12, by = 2)]) +
        # theme_few(20) +
        scale_alpha_manual("", values = c(1, 0.3), drop = FALSE) +
        scale_linetype_manual("", values = c("dotted", "solid"), labels = c("Long-term mean", "2020"), drop = FALSE) +
        scale_shape_manual(values = c(1, 16), drop = FALSE) +
        scale_colour_manual("", values = clrset, labels = c("", "", "", "", "", "", "Covid"), drop = FALSE) +
        scale_fill_manual(values = clrset, drop = FALSE) +
        guides(fill = FALSE,
               colour = guide_legend(
                 override.aes = list(colour = c(NA, NA, NA, NA, NA, NA, "#a65628"),
                                     shape = NA), order = 1)) +
        theme(legend.title = element_blank())
      
    } else if(input$inAdm1 == "Indicator"){
      
      g2 <- ggplot(dAdm1$dat) +
        geom_line(aes(x = month, y = value, colour = colourgroup,
                      linetype = linegroup, alpha = alphagroup, group = interaction(mygroup, alphagroup, linegroup, colourgroup))) +
        geom_point(aes(x = month, y = value_point, colour = colourgroup,
                       shape = pointgroup), size = 2) +
        geom_ribbon(data = dAdm1$ribbon, 
                    aes(x = month, ymin = minval, ymax = maxval, fill = colourgroup), colour = NA, alpha = 0.1) +
        facet_wrap(~ admin_level_1, scales = "free") +
        ggtitle(paste(dAdm1$dat$country[1], " - " ,input$inAdm1Indi, sep = "")) +
        xlab("") + 
        ylab("Cases per 1K people") +
        scale_x_continuous(breaks = seq(from = 1, to = 12, by = 2), labels = month.abb[seq(from = 1, to = 12, by = 2)]) +
        # theme_few(16) +
        scale_alpha_manual("", values = c(1, 0.3), drop = FALSE) +
        scale_linetype_manual("", values = c("dotted", "solid"), labels = c("Long-term mean", "2020"), drop = FALSE) +
        scale_shape_manual(values = c(1, 16), drop = FALSE) +
        scale_colour_manual("", values = clrset, labels = c("", "", "", "", "", "", "Covid"), drop = FALSE) +
        scale_fill_manual(values = clrset, drop = FALSE) +
        guides(fill = FALSE,
                colour = guide_legend(
                  override.aes = list(colour = c(NA, NA, NA, NA, NA, NA, "#a65628"),
                                      shape = NA), order = 1)) +
        theme(legend.title = element_blank())
    }
    
    print(g2)
    
  })
  
  
  
  ## COVID Risk mapping plot -------------------------------------------------------------------
  ## Right now the map is only for Guinea
  ## Will need to add functions to map user-selected
  ## countries
  
  output$mapCovid <- renderLeaflet(
    
    leaflet(s) %>%
      setView(2.25, 9, zoom = 7) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  # opacity = 1.0, 
                  # fillOpacity = 0.5,
                  # fillColor = ~pal(FinalRank)
                  fillColor = ~colorQuantile("YlOrRd", FinalRank, n = 9)(FinalRank))    %>%
       addLegend("topright", pal = colorQuantile("YlOrRd", s$FinalRank, n = 9),
                 values = ~ FinalRank,
              title = "Risk Ranking", 
                opacity = 1)
      
    
  )
  
  output$mapElderly <- renderLeaflet(
    leaflet(s) %>%
      setView(2.25, 9, zoom = 7) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  # opacity = 1.0, 
                  # fillOpacity = 0.5,
                  # fillColor = ~pal(FinalRank)
                  fillColor = ~colorQuantile("YlGnBu", ElderlyPop, n = 9)(ElderlyPop))   # %>%
      # addLegend("topright", pal = colorQuantile("YlGnBu", s$ElderlyPop, n = 9),
      #           values = ~ ElderlyPop,
      #           title = "Population", 
      #           opacity = 1)
    
  )
  
  
  output$mapPopDen <- renderLeaflet(
    leaflet(s) %>%
      setView(-2.25, 9, zoom = 7) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                  # opacity = 1.0, 
                  # fillOpacity = 0.5,
                  # fillColor = ~pal(FinalRank)
                  fillColor = ~colorQuantile("BuPu", PopDens, n = 9)(PopDens))   # %>%
      # addLegend("topright", pal = colorQuantile("BuPu", s$PopDens, n = 9),
      #           values = ~ PopDens,
      #           title = "Density", 
       #          opacity = 1)
    
  )
  
  
}
  
  
  
