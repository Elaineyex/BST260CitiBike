library(shiny)
library(shinyWidgets)
library(leaflet)
library(tidyverse)
# library(classInt)
library(geosphere)

bikedata <- read_csv("bikestation_dailytrips.csv")
sampleddata <- read_csv("bikedata_sampled_1percent.csv")
attractionsdata <- read_csv("NYCAttractions.csv")

#total start/end trips per station for the year
yearlytotal <- bikedata %>% 
  group_by(station_id, station_name, station_longitude, station_latitude) %>%
  summarize(totalstarts = sum(startcount, na.rm=TRUE),
            totalends = sum(endcount, na.rm=TRUE),
            totaltrips = totalstarts+totalends) %>%
  arrange(desc(totaltrips))

# icons for map
icon.ion <- makeAwesomeIcon(icon= 'star', markerColor = 'darkblue', library = "ion", iconColor = 'white')
icon.start <- makeAwesomeIcon(icon= 'star', markerColor = 'green', library = "ion", iconColor = 'white')
icon.end <- makeAwesomeIcon(icon= 'star', markerColor = 'red', library = "ion", iconColor = 'white')
icon.bike <- makeAwesomeIcon(icon= 'bicycle', markerColor = 'lightblue', library = "fa", iconColor = 'white')

# add trip duration (biketime) to the trip data, remove rides that are longer than 2 hrs
sampleddata <- sampleddata %>% mutate(biketime = as.numeric(round((stop_time - start_time),2))) %>% filter(biketime < (120))

ui <- fluidPage(
  setSliderColor("#379DDA", 1),
  # Give the page a title
  titlePanel("NYC Citi Bikes"),
  tabsetPanel(
    tabPanel("Exploring NYC on Bike",
             sidebarLayout(
               sidebarPanel(
                 img(src = "citibikelogo_resized.png", height = 100, width = 100, style="display: block; margin-left: auto; margin-right: auto;"),
                 h5("Experience NYC in a whole new way. Use this app to plan your trip to top destinations across the city."),
                 selectInput("Start", "Select starting point:", attractionsdata$attraction, selected="Times Square"),
                 sliderInput("Closest", "View closest N stations:", min=1, max=20, value=10, ticks=FALSE, step=1),
                 selectInput("Destination", "Select destination:", attractionsdata$attraction, selected="Brooklyn Bridge"),
                 htmlOutput("selected_var"),
                 h2(" "),
                 plotOutput("hist")
               ),
               mainPanel(leafletOutput("map"),
                         plotOutput("busy")
                         )
             )
    )
    # ,tabPanel("Tab2")
  )  
)

server <- function(input, output, session) {

  output$selected_var <- renderText({ 
    paste("Your selected destination is ", 
          "<font color=\"#379DDA\"><b>",
          distance(),
          "</b></font>",
          " miles away. In the city, it takes ~8 min/mile, so your estimated bike time is ",
          "<font color=\"#379DDA\"><b>",
          time(),
          "</b></font>",
          " minutes.")
  })
  
  output$hist <- renderPlot({ 
    ggplot(sampleddata, aes(biketime)) +
      geom_histogram(binwidth = 5, fill = "lightblue1", color = "white") +
      scale_x_continuous(limits=c(0,60), breaks = seq(0,60,10)) +
      scale_y_continuous(expand = c(0, 0)) +
      geom_vline(xintercept=time(), color="#379DDA", size=1.5) +
      annotate(geom = "text", label = "Your Trip", x = time(), y = 40000, hjust = -0.1, color="#379DDA", size=5) +
      labs(x="bike times of other riders (in minutes)", y="") +
      theme(axis.ticks.y = element_blank(),
            axis.text.y = element_blank(),
            axis.line.x = element_line(color="black"),
            panel.grid = element_blank(),
            panel.background = element_rect(fill="#F5F5F5", color="#F5F5F5"),
            plot.background = element_rect(fill="#F5F5F5", color="#F5F5F5"),
            axis.text.x = element_text(size=14),
            axis.title.x = element_text(size=14)
      )
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(lng = -73.98928, lat = 40.75042, zoom = 12) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addAwesomeMarkers(~long, ~lat,
                        popup = ~as.character(attraction),
                        label = ~as.character(attraction),
                        labelOptions = labelOptions(noHide = T),
                        icon = icon.ion,
                        data = attractionsdata)
  })
  
  # lat/long for selected attraction
  selected <- reactive({
    subset(attractionsdata, attraction == input$Start) 
  })  
  
  destination <- reactive({
    subset(attractionsdata, attraction == input$Destination) 
  })    
  
  # attraction data without selected (for marker coloring)
  nonselected <- reactive({
    subset(attractionsdata, attraction != input$Start) 
  })  
  
  # draw line between start/end
  startend <- reactive({
    subset(attractionsdata, attraction %in% c(input$Start, input$Destination)) 
  })    
  
  # calculate distance between start/end
  distance <- reactive({
    round(as.numeric(distm(c(selected()$long, selected()$lat), 
                     c(destination()$long, destination()$lat), 
                     fun = distHaversine)/1609),2)
  })
  
  time <- reactive({round(distance() * 8)})
  
  # get stations within n miles
  milesaway <- reactive({
    yearlytotal %>% 
      mutate(milesaway = as.numeric(distm(c(station_longitude, station_latitude), 
                                          c(selected()$long, selected()$lat), 
                                          fun = distHaversine)/1609)) %>%
      arrange(milesaway) %>%
      head(n=input$Closest)
  })    
  
  
  observe({
    leafletProxy('map') %>% 
      setView(lng =  selected()$long, lat = selected()$lat, zoom = 15) %>%
      clearMarkers() %>%
      clearShapes() %>%
      # addAwesomeMarkers(~long, ~lat,
      #                   popup = ~as.character(attraction),
      #                   label = ~as.character(attraction),
      #                   icon = icon.ion,
      #                   data = nonselected()) %>%
      addAwesomeMarkers(~long, ~lat,
                        popup = ~as.character(attraction),
                        label = ~as.character(attraction),
                        labelOptions = labelOptions(noHide = T),
                        icon = icon.start,
                        data = selected()) %>%      
      addAwesomeMarkers(~long, ~lat,
                        popup = ~as.character(attraction),
                        label = ~as.character(attraction),
                        labelOptions = labelOptions(noHide = T),
                        icon = icon.end,
                        data = destination()) %>%            
      addAwesomeMarkers(~station_longitude, ~station_latitude,
                        popup = ~as.character(station_name),
                        label = ~as.character(station_name),
                        icon = icon.bike,
                        data = milesaway()) %>%
      addAwesomeMarkers(~station_longitude, ~station_latitude,
                        popup = ~as.character(station_name),
                        label = ~as.character(station_name),
                        icon = icon.bike,
                        data = milesaway()) %>%
      addPolylines(data = startend(), ~long, ~lat, color = "black")
    

    output$busy <- renderPlot({
      milesaway() %>%
      ggplot(aes(reorder(station_name, totaltrips), totaltrips, fill=totaltrips)) +
        geom_bar(stat="identity") +
        geom_text(aes(label = scales::comma(totaltrips)), hjust = "inward", color="black", size=5)+
        scale_fill_continuous(trans = 'reverse') +
        scale_y_continuous(position = "right") +
        scale_fill_gradient(low = "azure1", high = "#38AADD") +
        coord_flip() +
        labs(title = "How busy were these stations in 2020?",
             x = "",
             y = "total bike trips that were started/ended at the station") +
        theme_minimal() +
        theme(legend.position = "none",
              panel.grid = element_blank(),
              panel.border = element_blank(),
              axis.text.x = element_blank(),
              axis.text.y = element_text(size=14),
              axis.title = element_text(size=14),
              axis.ticks = element_blank(),
              plot.title.position = "plot",
              plot.title = element_text(size=20))
    })

  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
