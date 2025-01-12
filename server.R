#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# The server logic will use frequency tables developed from provided corpora to 
# predict text based on user-supplied input.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(tidyverse)
library(tidytext)
library(stringr)
library(textclean)
library(data.table)

source("./Ngram Prediction2.R")

#unigram_freq <- readRDS(file= "./N_Grams/unigrams.rds") #Frequency Table of 1-grams
#bigram_freq <- readRDS(file= "N_Grams/bigrams.rds") #Frequency Table of 2-grams
Top.bigrams <- readRDS(file= "N_Grams/TopBigrams.rds")
#trigram_freq <- readRDS(file= "./N_Grams/trigrams.rds") #Frequency Table of 3-grams
#all_text <- readRDS(file= "./CleanCorpus.rds") #Cleaned process text from combined text files

#======== Define server logic required to predict text
shinyServer(function(input, output) {

  
  Text.pred <- reactive({
    userInputText <- input$Text1
    
   predict_next_word(userInputText, Top.bigrams, 2)
    
  })

# Function waits for Submit button to be pressed prior to computing next word.  
  
  output$pred1 <- renderText({
    
  Text.pred()
  
  })
})

