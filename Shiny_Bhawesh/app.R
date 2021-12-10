#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(dslabs)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(ggpubr)
library(tidyverse)

load("bikedata_summarized.RData")
shinyApp(
  ui <- fluidPage(
    
    # App title
    titlePanel(h1("Impact of Covid and Weather on Daily Trips", align = "center")),
    br(),
    br(),
    tabsetPanel(
      tabPanel("Weather Impact",
               sidebarLayout(
                 sidebarPanel(
                   
                   sliderInput("tempmax", "Day Max Temprature:",
                               min = 14, max = 100,
                               value = c(40, 80)),
                   
                   sliderInput("tempmin", "Day Min Temprature:",
                               min = 2, max = 90,
                               value = c(20,60)),
                   
                   sliderInput("windspeed", "Average Wind Speed:",
                               min = .9, max = 15,
                               value = c(0.9,10)),
                   
                   
                   sliderInput("rainfall", "Precipitation:",
                               min = 0, max = 1,
                               value = c(0,0.2)),
                   
                   
                   
                 ),
                 
                 mainPanel(
                   
                   plotOutput("boxplot")
                   
                 )
               )),
      tabPanel("Covid Impact",
               br(),
               br(),
               p(h4("Covid-19 impacted mobility significantly. Here we compare the number of trips for citibike across NYC for 2019 and 2020."
                    , align = "center" )  ),
               
               
               br(),
               sidebarLayout(
                 sidebarPanel(
                   
                   
                   sliderInput("month_range", "Month Range:",
                               min = 1, max = 12,
                               value = c(1, 12))),
                 
                 
                 mainPanel(
                   plotOutput("linePlot")
                 )
                 
                 
               ))
    )),
  
  server <- function(input, output) {
    
    output$boxplot = renderPlot({
      bikedata_summarized %>% filter(AWND>=input$windspeed[1], AWND<=input$windspeed[2],PRCP>=input$rainfall[1],
                                     PRCP<=input$rainfall[2],TMAX>=input$tempmax[1], TMAX<=input$tempmax[2],
                                     TMIN>=input$tempmin[1], TMIN<=input$tempmin[2]) %>%ggplot(aes(as.factor(year),trips_7dayavg,group=as.factor(year)))+geom_boxplot(aes(fill=as.factor(year))) +theme(legend.position = "none")+coord_cartesian(ylim = c(0, 5000))+labs(x = "Year", y = "daily trips (7-day rolling mean)", color = "Year\n") +scale_color_manual(values = c("green", "red"))+theme(axis.text.x = element_text(angle = 90, hjust = 1)) +xlab("")+ggtitle("Boxplot of Daily Trips Across 2019 and 2020")+theme(plot.title = element_text(hjust = 0.5))
    })
    
    output$linePlot = renderPlot({
      labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug",
                 "Sep", "Oct", "Nov", "Dec")
      ggplot(data = bikedata_summarized%>%filter(daynum<=input$month_range[2]*(30), daynum>=(input$month_range[1]-1)*30), aes(x = daynum, y = trips_7dayavg, group=as.factor(year)))+
        geom_line(aes(color=as.factor(year)))+
        labs(x = "Month", y = "daily trips (7-day rolling mean)", color = "Year\n") +
        scale_color_manual(values = c("green", "red"))+
        scale_x_continuous(breaks=seq((input$month_range[1]-1)*30+1,input$month_range[2]*30, 30), labels = labels[input$month_range[1]:input$month_range[2]])+
        scale_y_continuous(labels = scales::comma) +
        ggtitle (paste0("Trips in NYC between ", labels[input$month_range[1]],"-", labels[input$month_range[2]], " for 2020 and 2021"))+
        theme_light() +theme(plot.title = element_text(hjust = 0.5))+
        theme(panel.grid.minor = element_blank(),
              panel.grid.major.x = element_blank()
        )
      
    })
    
    
  })
