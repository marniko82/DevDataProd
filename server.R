# server.R
library(shiny)
library(leaflet)
library(caret)
library(rpart)
library(randomForest)

model <- readRDS("./data/model.rds")
TitanicData <- readRDS("./data/TitanicData.rds")

map = leaflet() %>% addTiles() %>% setView(lng = -5, lat = 50, zoom = 4) 
coords <- list(c(-1.4, 50.9),c(-1.61,49.64),c(-8.3,51.86)) #Southampton, Cherbourg and Queenstown

passenger <- data.frame(Pclass="3", Sex="male", Age=21, Fare=15, Embarked="S",
                        Title="Mr", FamilySize=2)


shinyServer(function(input, output) {

  output$textName <- renderText({ 
    paste("Good day", input$title, input$name,"!")
  })
  
  output$textGoGo <- renderText({ 
    paste(input$title, input$name,"are you ready to find out?")
  })
  
  
  output$textTitle <- renderText({
    output$textUpdate <- renderText({"Please recalculate"})
    if(input$title %in% c("Col","Dr","Lady","Rev","Sir")){
      "Make way for the upper class!"
    } else
      "Nice to see a fellow commoner."
   })

  rSex <- reactive ({
    output$textUpdate <- renderText({"Please recalculate"})
    if (input$sex=="1"){
      list(src=normalizePath(file.path('www','images','male.png')),
           contentType = 'image/png', width=30, height=30, alt="Guy")
    } else 
      list(src=normalizePath(file.path('www','images','female.png')),
           contentType = 'image/png',width=30, height=30, alt="Gal")
  })

  output$imageSex <- renderImage({
    rSex()
  }, deleteFile = FALSE)
  
  
  rAge <- reactive ({
    output$textUpdate <- renderText({"Please recalculate"})
    paste("You are older than",round(100*ecdf(TitanicData$Age)(input$age),0),"% of people in the Titanic data sample.")
    })
  
  output$textAge <- renderText({ 
    rAge()
  })
 
  rFamily <- reactive ({
    output$textUpdate <- renderText({"Please recalculate"})
    if (input$family>7){
      "That is a large family!"
    } else if (input$family==0){
      "Travelling alone is no fun!"
    } else
      "A common family size in the early 20th century"    
      })
  
  output$textFamily <- renderText({ 
    rFamily()
  }) 
  
  rFare <- reactive ({
    output$textUpdate <- renderText({"Please recalculate"})
    if (input$fare>mean(TitanicData$Fare)){
      "Your above-average Joe"
    } else if (input$fare==0){
      "A stowaway!"
    } else
      "Nothing to see here."    
  })
  
  output$textFare <- renderText({ 
    rFare()
  })   
  
  rClass <- reactive ({
    output$textUpdate <- renderText({"Please recalculate"})
    if (input$class=="1"){
      "Travelling in style!"
    } else if (input$class=="3"){
      "Say hi to Jack Dawson for me!"
    } else
      "Nothing to see here."    
  })
  
  output$textClass <- renderText({ 
    rClass()
  })     

  rMap <- reactive ({
    output$textUpdate <- renderText({"Please recalculate"})
    lati <- switch(input$town, 
                   "Southampton" = coords[[1]][2],
                   "Cherbourg" = coords[[2]][2],
                   "Queenstown" = coords[[3]][2])
    
    longi <- switch(input$town, 
                  "Southampton" = coords[[1]][1],
                  "Cherbourg" = coords[[2]][1],
                  "Queenstown" = coords[[3]][1])    
    
    map <- map %>% addCircleMarkers(lng=longi, lat=lati)
    
  }) 

  output$mapTown <- renderLeaflet({ 
    rMap()
  })    
  
  finalCalc <- eventReactive(input$submit, {
   passenger$Pclass <- input$class
   passenger$Sex <- switch(input$sex,
                           "1"="male",
                           "2"="female")
   passenger$Age <- input$age
   passenger$Fare <- input$fare
   passenger$Embarked <- switch(input$town,
                                "Southampton" = "S",
                                "Cherbourg" = "C",
                                "Queenstown" = "Q")
   passenger$Title <- input$title
   passenger$FamilySize <- input$family
   
   outcome <- predict(model, passenger)
   output$textUpdate <- renderText({"Up to date"})
   
   if (outcome==0){
     "You DID NOT survive!"
   } else
     "You survived! Huzzah!"

  })

  output$textFinal <- renderText({ 
    finalCalc()
  })   


})
  
 

