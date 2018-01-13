library(toaster)
library(tm)
library(topicmodels)
library(data.table)
library(plyr)
# install.packages('SnowballC')
# initialize connection to Lahman baseball database in Aster 
conn = odbcDriverConnect(connection="driver={Aster ODBC Driver};
                         server=192.168.100.220;port=2406;database=beehive;
                         uid=beehive;pwd=beehive")

# Loading dataframe videos_titles_description_sample

df_vtds = computeSample(conn, 
                        tableName="prdwa17_batch_load.videos_titles_descriptions",
                        sampleFraction=1)
  
corpus <- Corpus(VectorSource(as.character(df_vtds$content))) 

cleaned_corpus <- tm_map(corpus, stripWhitespace)
# cleaned_corpus <- tm_map(cleaned_corpus, content_transformer(tolower))

#cleaned_corpus <- tm_map(cleaned_corpus, 
#                           rm_punctuation_f, 
#                           "[!\"#$%&'*+,./)(:;<=>?@\\^`{|}~'"""'-_][]]")
# cleaned_corpus <- tm_map(cleaned_corpus, removeWords, stopwords("english"))
# 
# cleaned_corpus <- tm_map(cleaned_corpus, removePunctuation, 
#                          preserve_intra_word_contractions = TRUE,
#                          preserve_intra_word_dashes = TRUE)
# cleaned_corpus <- tm_map(cleaned_corpus, stemDocument)

dtm = DocumentTermMatrix(cleaned_corpus,  
                         control = list(
                           tolower = TRUE,
                           removePunctuation = TRUE,
                           ## (standard tm tokenizer, see termFreq)
                           removeNumbers= TRUE,
                           stemming = TRUE,
                           stopwords = TRUE,
                           minWordLength = 3))
freq <- colSums(as.matrix(dtm))
ord <- order(freq,decreasing=TRUE)
# Windows charset = ISO-8859-1
csv_file <- file("word_freq.csv", "wb",encoding="UTF-8")
write.csv(freq[ord],csv_file)
close(csv_file)

VEM = LDA(dtm, k = 10, control = list(seed = Sys.time()))
videos_topics = topics(VEM)
content = df_vtds$content
df_vtds_with_topics = data.frame(content, videos_topics)
#agg = aggregate(videos_topics ~ content, df_vtds_with_topics, )
topics_counts <- count(df_vtds_with_topics, c("videos_topics"))