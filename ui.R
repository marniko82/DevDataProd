library(shiny)
library(leaflet)

dd_titles_list <- as.list(c("Col","Dr","Lady","Master","Miss","Mlle","Mr","Mrs","Ms","Rev","Sir"))
dd_board_list <- as.list(c("Southampton","Cherbourg","Queenstown"))
dd_class_list <- as.list(c("1","2","3"))

c1_width <- 3
c2_width <- 3
c3_width <- 1
c4_width <- 5

shinyUI(fluidPage(
  titlePanel("Titanic: Would you survive the disaster?"),
  p("The sinking of RMS Titanic is one of the best known maritime disasters in history. 
           Titanic was on its maiden voyage from Southampton to New York when in the early morning on 
           15 April 1912 the ship hit an iceberg and sunk, resulting in the loss of more than 1,500
           people. Titanic carried many different types of passengers, from the homeless to Johnkeer and from babies 
    to old men. It turns out that some passengers were more 
    likely to survive, depending on many factors. This web app, using machine learning techniques, tries to answer the most burning question the reader 
    might have:"),
  strong("Would you survive the sinking of the Titanic?"),
  p("Enter your name and other required information and find out!"),
  fluidRow(
    column(c1_width,
           textInput("name", label = h5("Your name"), 
                     value = "Enter your name")),
    column(c2_width,
           br(),
           br(),
           em(textOutput("textName"))),  
    column(c3_width,
           br())
   ),
  fluidRow(
    column(c1_width,
           selectInput("title", label = h5("Your title"), 
                       choices = dd_titles_list, selected="Mr")),
    column(c2_width,
           br(),
           br(),
           em(textOutput("textTitle"))),  
    column(c3_width,
           br()),
    column(c4_width,
           strong(textOutput("textGoGo")),align="center")
  ),
  fluidRow(
    column(c1_width,
           radioButtons("sex", label = h5("Your gender"),
                        choices = list("Male" = 1, "Female" = 2),selected = 1)),
    column(c2_width,
           br(),
           br(),
           imageOutput("imageSex",height="5px")),  
    column(c3_width,
           br()),
    column(c4_width,
           actionButton("submit", "Go!"),align="center")    

  ),
  
  fluidRow(
    column(c1_width, 
           numericInput("family", 
                        label = h5("How many people are traveling with you? (0-12)"), 
                        value = 2,min=0, max=12)),      
    column(c2_width,
           br(),
           br(),
           em(textOutput("textFamily"))),  
    column(c3_width,
           br()),
    column(c4_width,
           br(),
           br(),
           em(textOutput("textUpdate")),align="center")     
    
  ),
  
  fluidRow(
    column(c1_width, 
           numericInput("fare", 
                        label = h5("How much did you pay for the ticket in GBP? (0-600)"), 
                        value = 15,min=0, max=600)),    
    column(c2_width,
           br(),
           br(),
           em(textOutput("textFare"))),  
    column(c3_width,
           br()),
    column(c4_width,
           h3(textOutput("textFinal")),align="center")    
  ),

  fluidRow(
    column(c1_width,
           selectInput("class", label = h5("Your ticket class"), 
                       choices = dd_class_list, selected="3")),
    column(c2_width,
           br(),
           br(),
           em(textOutput("textClass"))),  
    column(c3_width,
           br())    
  ),  
  
  fluidRow(
    column(c1_width, 
           numericInput("age", 
                        label = h5("Your age (0-100)"), 
                        value = 21,min=0, max=100)),   
    column(c2_width,
           br(),
           br(),
           em(textOutput("textAge"))),  
    column(c3_width,
           br())   
  ),
  fluidRow(
    column(c1_width,
           selectInput("town", label = h5("Town where you boarded?"), 
                       choices = dd_board_list, selected="Southampton")),
    column(c2_width,
           leafletOutput("mapTown", height=200)),  
    column(c3_width,
           br()),
    column(c4_width,
           #img(src=normalizePath(file.path('www','images','Titanic.jpg')), width=200, height=200),align="center")    
          img(src='images/Titanic.jpg', width=200, height=200),align="center")
  ),
  p("Acknowledgements: Kaggle.com for providing the data-set and Trevor Stephens 
    (trevorstephens.com) for a wonderful tutorial my analysis was based on. 
    Images downloaded from Wikipedia, credit: Stöwer Titanic by Willy Stöwer, 
    died on 31st May 1931.")

))