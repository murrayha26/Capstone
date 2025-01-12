library(tidyverse)
library(tidytext)
library(stringr)
library(textclean)
library(data.table)

#unigram_freq <- readRDS(file= "./Next-Word-Predictor/N_Grams/unigrams.rds") #Frequency Table of 1-grams
#bigram_freq <- readRDS(file= "N_Grams/bigrams.rds") #Frequency Table of 2-grams
Top.bigrams <- readRDS(file= "N_Grams/TopBigrams.rds") #Frequency Table of 2-grams
#trigram_freq <- readRDS(file= "./Next-Word-Predictor/N_Grams/trigrams.rds") #Frequency Table of 3-grams
#all_text <- readRDS(file= "./Next-Word-Predictor/N_Grams/CleanCorpus.rds") #Cleaned process text from combined text files

#----- App gave me 'Disconnected from server error when I used the entire bigram_freq. will try a smaller sample
#----- Plan is to convert bigram_freq to CSV and use sampleFile function to get a smaller version of bigrams to run app from.

#write.csv(bigram_freq, "bigrams.csv")
#bigramSample <- sampleFile("bigrams.csv", .05)



#=========================== N-GRAM PREDICTION =================================
# Function to preprocess text
preprocess_text <- function(data) {
  data %>%
    mutate(text = str_to_lower(text)) %>%                # Convert to lowercase
    mutate(text = replace_non_ascii(text)) %>%          # Remove non-ASCII characters
    mutate(text = str_remove_all(text, "http[[:alnum:]]*")) %>%  # Remove URLs
    mutate(text = str_remove_all(text, "[[:punct:]]")) %>%  # Remove punctuation
    mutate(text = str_remove_all(text, "[[:digit:]]")) %>%  # Remove digits
    mutate(text = str_squish(text))                     # Remove extra whitespace
}

# Function to create n-gram frequency tables
create_ngram_freq <- function(data, n) {
  data %>%
    unnest_tokens(output = "ngram", input = "text", token = "ngrams", n = n) %>%
    anti_join(stop_words, by = c("ngram" = "word")) %>%  # Remove stop words
    count(ngram, sort = TRUE)
}

# Function to take a sample of the N-Gram data frame
# Function to take a random sample of a data frame
sample_dataframe <- function(df, sample_size, replace = FALSE) {
  if (sample_size > nrow(df)) {
    stop("Sample size cannot be larger than the number of rows in the data frame.")
  }
  
  sampled_df <- df[sample(seq_len(nrow(df)), size = sample_size, replace = replace), ]
  return(sampled_df)
}

# Example usage:
# Assuming `data` is your data frame:
# random_sample <- sample_dataframe(data, sample_size = 10)

# Function for next-word prediction
predict_next_word <- function(input_text, ngram_freq, n) {
  # Tokenize input text into n-grams of size n-1
  tokens <- unnest_tokens(tibble(text = input_text), output = "ngram", input = "text", token = "ngrams", n = n - 1)
  
  # Get the last n-1 words
  last_ngram <- tokens$ngram[length(tokens$ngram)]
  
  # Filter the n-gram frequency table for matches
  predicted <- ngram_freq %>%
    filter(str_starts(ngram, paste0(last_ngram, " "))) %>%
    arrange(desc(n)) %>% 
    slice_head(n=3) # Select the top 3 predictions
  
  # Extract only the next words
  predicted_words <- predicted %>%
    mutate(next_word = str_extract(ngram, paste0("(?<=", last_ngram, " ).*"))) %>%
    pull(next_word)
  
  # Return the top next words
  predicted_words
}

 
