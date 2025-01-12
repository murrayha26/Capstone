#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that predicts the next words given user-supplied text
shinyUI(fluidPage(

    # Application title
    titlePanel("Next Word Predictor"),

    # Sidebar with a text input box to capture user input
    sidebarLayout(
        sidebarPanel(
          
          textInput("Text1", "Enter text:"),
          submitButton("Predict next words")
                        
        ),

        # Show next 3 likely words based on frequency table
        mainPanel(
          h3("Prediction Results"),
          h4("Predicted Next Words:"),
          textOutput("pred1")
        )
    )
))
