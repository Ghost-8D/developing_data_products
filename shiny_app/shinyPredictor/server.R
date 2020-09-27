#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Author: Panayiotis L.
# Date: 27 Sep 2020
# Version: 1.0
#

library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(plotly)

shinyServer(function(input, output) {
    
    calc_rmse <- function(pred, pdata) {
        sqrt(mean((pred - pdata$price)^2))
    }
    
    m1 <- lm(price ~ carat + cut, data = diamonds)
    m2 <- lm(price ~ carat, data = diamonds)
    
    model1_pred <- predict(m1, newdata=select(diamonds, -price))
    model2_pred <- predict(m2, newdata=select(diamonds, -price))
    
    model1_rmse <- calc_rmse(model1_pred, diamonds)
    model2_rmse <- calc_rmse(model2_pred, diamonds)
    
    pred_diff <- model1_rmse - model2_rmse
    
    output$rmse1 <- renderText({
        model1_rmse
    })
    
    output$rmse2 <- renderText({
        model2_rmse
    })
    
    getCutFactor <- function(cutValue){
        if (cutValue == 1) {
            cutFactor <- 'Fair'
        } else if (cutValue == 2){
            cutFactor <- 'Good'
        } else if (cutValue == 3){
            cutFactor <- 'Very Good'
        } else if (cutValue == 4){
            cutFactor <- 'Premium'
        } else {
            cutFactor <- 'Ideal'
        }
    }
    
    output$plot1 <- renderPlot({
        caratInput <- input$sliderCarat
        cutInput <- input$sliderCut
        
        plot(diamonds$carat, diamonds$price, xlab = "Carat value", 
             ylab = "Diamond price", pch = 18, col=diamonds$cut, ylim = c(0, 30000))
        if (input$showModel1){
            abline(m1, col = "blue", lwd = 2)
        }
        if (input$showModel2){
            abline(m2, col = "green", lwd = 2)
        }
        legend("topleft", c("Model 1 Prediction", "Model 2 Prediction"), pch = 18, 
               col = c("blue", "green"), bty = "n", cex = 1.2)
        points(caratInput, model1pred(), col = "blue", pch = 18, cex = 3)
        points(caratInput, model2pred(), col = "green", pch = 18, cex = 3)
    })
    
    output$plot2 <- renderPlot({
    })
    
    model1pred <- reactive({
        caratInput <- input$sliderCarat
        cutInput <- input$sliderCut
        cutFactor <- getCutFactor(cutInput)
        predict(m1, newdata = data.frame(carat=caratInput, cut=cutFactor))
    })
    
    model2pred <- reactive({
        caratInput <- input$sliderCarat
        predict(m2, newdata = data.frame(carat=caratInput))
    })
    
    output$pred1 <- renderText({
        model1pred()
    })
    
    output$pred2 <- renderText({
        model2pred()
    })
    
})
