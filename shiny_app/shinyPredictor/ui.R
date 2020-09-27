#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Author: Panayiotis L.
# Date: 27 Sep 2020
# Version: 1.0
#
# Usage: Use the sliders to select values for carat and cut type and click submit
# to get price predictions from the two linear models.
#

library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("Fitting Linear Regression models on Diamonds Data"),

    sidebarLayout(
        sidebarPanel(
            
            sliderInput("sliderCarat", "What is the carat value of the diamond?", 0.1, 5.1, value = 2.0),
            sliderInput("sliderCut", "What is the cut type of the diamond? (1: Fair, 2: Good, 3: Very Good, 4: Premium, 5: Ideal)", 1, 5, value = 1),
            checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
            checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
            submitButton("Submit")
        ),

        mainPanel(
            h3("RMSE for first model (linear regression with carat and cut variables)"),
            textOutput("rmse1"),
            h3("RMSE for second model (linear regression with carat variable)"),
            textOutput("rmse2"),
            plotOutput("plot1"),
            h3("Predicted price from Model 1:"),
            textOutput("pred1"),
            h3("Predicted price from Model 2:"),
            textOutput("pred2"),
            plotOutput("plot2"),
        )
    )
))
