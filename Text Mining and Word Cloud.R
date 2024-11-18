# Install and load the required packages
library("tm") # Text mining package for handling text data
library("SnowballC")  # Provides text stemming functionality
library("wordcloud") # Package for generating word clouds
library("RColorBrewer") # For color palettes in visualizations

# Text mining
# Import the text file and load the data as a corpus 
# The file.choose() function opens a file dialog for selecting a file
# Alternatively, you can specify the path of the file directly

text <- readLines(file.choose())
filePath <- "C:\\Users\\kanis\\OneDrive\\Documents\\speech.txt"
text <- readLines(filePath)
docs <- Corpus(VectorSource(text)) # Convert the text data into a corpus
inspect(docs) # Display the structure of the corpus to check its contents


# Text transformation
# The toSpace function replaces specific characters/patterns with spaces
# Applying toSpace function to remove special characters from the corpus

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

#Cleaning the text
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
# docs <- tm_map(docs, stemDocument)


# Build a term-document matrix  where rows are terms and columns are documents
dtm <- TermDocumentMatrix(docs) # Convert the corpus into a term-document matrix
m <- as.matrix(dtm) # Convert the term-document matrix into a regular matrix
v <- sort(rowSums(m),decreasing=TRUE) # Sort terms by their frequency (in decreasing order)
d <- data.frame(word = names(v),freq=v) # Create a data frame to store words and their frequencies
head(d, 10)


# Generate the Word cloud
# Set a random seed for reproducibility (so the word cloud looks the same each time)
# Maximum number of words to display
# If FALSE, most frequent words appear in the center
# 35% of the words will be rotated to appear vertically
# Use Dark2 color palette from RColorBrewer

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
