#' Title: Case study - NBA Fan Engagement
#' Subtitle: Text Analytics and NLP @ Hult International Business school
#' Author: Wai Hoi Li
#' Date: Jan 18 2021
#'

# Set the working directory
setwd("~/Desktop/hult_NLP_student/cases/NBA Fan Engagement/data")

# Libraries
library(tm)
library(qdap)
library(spelling)
library(hunspell)
library(mgsub)
library(pbapply)
library(tidyr)
library(stringr)
library(stringi)
library(dplyr)
library(tidyverse)
library(zoo)
library(lubridate)
library(wordcloud)
library(RColorBrewer)




# Options & Functions
options(stringsAsFactors = FALSE)
Sys.setlocale('LC_ALL','C')
set.seed(1000)

tryTolower <- function(x){
  y = NA
  try_error = tryCatch(tolower(x), error = function(e) e)
  if (!inherits(try_error, 'error'))
    y = tolower(x)
  return(y)
}

cleanCorpus<-function(corpus, customStopwords){
  toSpace <- content_transformer(function(x, pattern) gsub(pattern, "", x))
  corpus <- tm_map(corpus, content_transformer(qdapRegex::rm_url))
  corpus <- tm_map(corpus, content_transformer(replace_contraction)) 
  corpus <- tm_map(corpus, content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords, customStopwords)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, toSpace, "<.*?>")
  corpus <- tm_map(corpus, toSpace, "(rt|via)((?:\\b\\W*@\\w+)+)")
  corpus <- tm_map(corpus, toSpace, "\342\200\246")
  corpus <- tm_map(corpus, toSpace, "\342\200\234")
  corpus <- tm_map(corpus, toSpace, "\342\200\231")
  corpus <- tm_map(corpus, toSpace, "\360\237\217\200")
  corpus <- tm_map(corpus, toSpace, "\342\200\224")
  corpus <- tm_map(corpus, toSpace, "\342\200\223")
  corpus <- tm_map(corpus, toSpace, "\342\234\205")
  corpus <- tm_map(corpus, toSpace, "\342\200\235")
  corpus <- tm_map(corpus, toSpace, "\360\237\230\202")
  corpus <- tm_map(corpus, toSpace, "\342\200\242")
  corpus <- tm_map(corpus, toSpace, "\342\230\230\357\270\217")
  corpus <- tm_map(corpus, toSpace, "\U0001f4")
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, stripWhitespace)
  return(corpus)
}

bigramTokens <-function(x){
  unlist(lapply(NLP::ngrams(words(x), 2), paste, collapse = " "), 
         use.names = FALSE)
}

cleanMatrix <- function(pth, columnName, collapse = F, customStopwords, 
                        type, wgt){
  
  print(type)
  
  if(grepl('.csv', pth, ignore.case = T)==T){
    print('reading in csv')
    text      <- read.csv(pth)
    text      <- text[,columnName]
  }
  if(grepl('.fst', pth)==T){
    print('reading in fst')
    text      <- fst::read_fst(pth)
    text      <- text[,columnName]
  } 
  if(grepl('csv|fst', pth, ignore.case = T)==F){
    stop('the specified path is not a csv or fst')
  }
  
  
  if(collapse == T){
    text <- paste(text, collapse = ' ')
  }
  
  print('cleaning text')
  txtCorpus <- VCorpus(VectorSource(text))
  txtCorpus <- cleanCorpus(txtCorpus, customStopwords)
  
  if(type =='TDM'){
    if(wgt == 'weightTfIdf'){
      termMatrix    <- TermDocumentMatrix(txtCorpus, 
                                          control = list(weighting = weightTfIdf))
    } else {
      termMatrix   <- TermDocumentMatrix(txtCorpus)
    }
    
    response  <- as.matrix(termMatrix)
  } 
  if(type =='DTM'){
    if(wgt == 'weightTfIdf'){
      termMatrix   <- DocumentTermMatrix(txtCorpus, 
                                         control = list(weighting = weightTfIdf))
    } else {
      termMatrix    <- DocumentTermMatrix(txtCorpus)
    }
    response  <- as.matrix(termMatrix)
    if(grepl('dtm|tdm', type, ignore.case=T) == F){
      stop('type needs to be either TDM or DTM')
    }
    
    
  }
  print('complete!')
  return(response)
}

# Create custom stop words # run word frequency
stops <- c(stopwords('SMART'), 'rt','nba', 'smh', 'and','cavs','game', 'games','season','basketball','team','win','year','tonight','it',
           'love','live','fans','night','points','pts','nov','play','usa','beat','time','los','angeles','miami','player','players',
           'home','power','league','rankings','ranking','back','today','point',"lmaooooo",'lmao','amp','forward','championship',
           'final',"finals",'playoffs','playoff','round','series','pick','picks')

#  Read data

txtFilesName <- list.files(path = "~/Desktop/Study/*Hult/*MsBA/*NLP/hult_NLP_student1/cases/NBA Fan Engagement/data")
txtFiles <- list.files(pattern = 'A_Oct2019|B_Nov2019|C_Dec2019|D_Jan2020|E_Feb2020|F_Mar2020|G_Apr2020|H_May2020|I_June2020|J_July2020|K_Aug2020|L_Sep2020|M_Oct2020|tweetbyteam')
filesname <- gsub('.{4}$', '', txtFilesName)
filesname
txtFilesName
#filesname <- c('A_Oct2019','B_Nov2019','C_Dec2019','D_Jan2020','E_Feb2020','F_Mar2020','G_Apr2020','H_May2020','I_June2020','J_July2020','K_Aug2020','L_Sep2020','M_Oct2020')


for (i in 1:length(txtFiles)){
  assign(txtFiles[i], read.csv(txtFiles[i], header = T))
  cat(paste('read completed:',txtFiles[i],'\n'))
}

tweetbyteam.csv <- read.csv(file = "tweetbyteam.csv", header = F)
head(tweetbyteam.csv)
colnames(tweetbyteam.csv) <- c("doc_id","text")


# delete all .csv from the file names and slice sample
A_Oct2019 <- slice_sample(A_Oct2019.csv,n=1000)
B_Nov2019 <- slice_sample(B_Nov2019.csv,n=1000)
C_Dec2019 <- slice_sample(C_Dec2019.csv,n=1000)
D_Jan2020 <- slice_sample(D_Jan2020.csv,n=1000)
E_Feb2020 <-slice_sample(E_Feb2020.csv,n=1000)
F_Mar2020 <- slice_sample(F_Mar2020.csv,n=1000)
G_Apr2020 <- slice_sample(G_Apr2020.csv,n=1000)
H_May2020 <- slice_sample(H_May2020.csv,n=1000)
I_June2020 <- slice_sample(I_June2020.csv,n=1000)
J_July2020 <- slice_sample(J_July2020.csv,n=1000)
K_Aug2020 <- slice_sample(K_Aug2020.csv,n=1000)
L_Sep2020 <- slice_sample(L_Sep2020.csv,n=1000)
M_Oct2020 <- slice_sample(M_Oct2020.csv,n=1000)
tweetbyteam <- slice_sample(tweetbyteam.csv,n=1000)

# Combine data
talkedteams <- vector(mode="double")
talkedteamsfreq <- vector(mode="double")
talkedtopic <- vector(mode="double")
talkedtopicfreq <- vector(mode="double")
total <- vector(mode="double")
totalteamlist <- vector(mode="double")
totaltopiclist <- vector(mode="double")
janteamlist <- vector(mode="double")
aprteamlist <- vector(mode="double")
mayteamlist <- vector(mode="double")
junteamlist <- vector(mode="double")
octteamlist <- vector(mode="double")
tweetbyteamlist <- vector(mode="double")
totalteamlist <- vector(mode="double")

# team name combined and text combined
total <- full_join(A_Oct2019, B_Nov2019, by = NULL)
total <- full_join(total, C_Dec2019, by = NULL)
total <- full_join(total, D_Jan2020, by = NULL)
total <- full_join(total, E_Feb2020, by = NULL)
total <- full_join(total, F_Mar2020, by = NULL)
total <- full_join(total, G_Apr2020, by = NULL)
total <- full_join(total, H_May2020, by = NULL)
total <- full_join(total, I_June2020, by = NULL)
total <- full_join(total, J_July2020, by = NULL)
total <- full_join(total, K_Aug2020, by = NULL)
total <- full_join(total, L_Sep2020, by = NULL)
total <- full_join(total, M_Oct2020, by = NULL)

names(total)


# seperate data according to teams
teamname <- unique(unlist(A_Oct2019$team))
teamname

splitedteamname <- tolower(str_split_fixed(teamname, " ", n=3))
splitedteamname
splitedteamnames <- splitedteamname

remains <- c(2,5,9,19,23,30)
n <- c(1,3,4,6,7,8,10:18,20,21,22,24:29)
for (i in n){
  splitedteamname[i,2] <- ""
}

splitedteamcity <- splitedteamname[,1:2]
splitedteamcity <- append(splitedteamcity,c("preseason","coach"))
splitedteamcity

# add the team's city into stops list
stops <- append(stops, splitedteamcity)
tail(stops)

# add the teams' names into the the custom stop word
stopswteamnames <- append(stops, splitedteamnames)
tail(stopswteamnames)


# Clean data
## Oct
txtCorpus <- VCorpus(VectorSource(A_Oct2019$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# oct best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# oct freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$oct19 <- team$terms
talkedteamsfreq$oct19 <- team$freq

# word associate to team
oct19teamassocteamword <- vector(mode="double")
for (i in 1:6){
  oct19teamassocteamword[talkedteams$oct19[[i]]] <- findAssocs(txtTdm, terms = talkedteams$oct19[[i]], corlimit = 0.3)
  
}
oct19teamassocteamword


#oct hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# oct freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$oct19 <- topic$terms
talkedtopicfreq$oct19 <- team$freq

oct19topicassocteamword <- vector(mode="double")
for (i in 1:10){
  oct19topicassocteamword[talkedtopic$oct19[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$oct19[[i]], corlimit = 0.3)
}
oct19topicassocteamword







## Nov
txtCorpus <- VCorpus(VectorSource(B_Nov2019$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# NOV best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Nov freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$nov19 <- team$terms
talkedteamsfreq$nov19 <- team$freq

# word associate to team
nov19teamassocteamword <- vector(mode="double")
for (i in 1:10){
  nov19teamassocteamword[talkedteams$nov19[[i]]] <- findAssocs(txtTdm, terms = talkedteams$nov19[[i]], corlimit = 0.3)
  
}
nov19teamassocteamword



# Nov hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Nov freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$nov19 <- topic$terms
talkedtopicfreq$nov19 <- topic$freq

# Nov associate
nov19topicassocteamword <- vector(mode="double")
for (i in 1:10){
  nov19topicassocteamword[talkedtopic$nov19[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$nov19[[i]], corlimit = 0.3)
}
nov19topicassocteamword









## Dec
txtCorpus <- VCorpus(VectorSource(C_Dec2019$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Dec best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Dec Freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$dec19 <- team$terms
talkedteamsfreq$dec19 <- team$freq

# word associate to team
dec19teamassocteamword <- vector(mode="double")
for (i in 1:10){
  dec19teamassocteamword[talkedteams$dec19[[i]]] <- findAssocs(txtTdm, terms = talkedteams$dec19[[i]], corlimit = 0.3)
  
}
dec19teamassocteamword

# Dec hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Dec freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$dec19 <- topic$terms
talkedtopicfreq$dec19 <- topic$freq

dec19topicassocteamword <- vector(mode="double")
for (i in 1:10){
  dec19topicassocteamword[talkedtopic$dec19[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$dec19[[i]], corlimit = 0.3)
}
dec19topicassocteamword






## Jan
txtCorpus <- VCorpus(VectorSource(D_Jan2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Jan best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Jan freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=20)

janteamlist <- head(frequencytable, n=20)
janteamlist <- janteamlist[-c(4),]
janteamlist[1:10,]
talkedteams$jan20 <- janteamlist$terms[1:10]
talkedteamsfreq$jan20 <- janteamlist$freq[1:10]

# word associate to team
jan20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  jan20teamassocteamword[talkedteams$jan20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$jan20[[i]], corlimit = 0.3)
  
}
jan20teamassocteamword

# Jan hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Jan Freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$jan20 <- topic$terms
talkedtopicfreq$jan20 <- topic$freq

jan20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  jan20topicassocteamword[talkedtopic$jan20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$jan20[[i]], corlimit = 0.3)
}
jan20topicassocteamword







## Feb2020
txtCorpus <- VCorpus(VectorSource(E_Feb2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Feb best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Feb freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$feb20 <- team$terms
talkedteamsfreq$feb20 <- team$freq

# word associate to team
feb20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  feb20teamassocteamword[talkedteams$feb20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$feb20[[i]], corlimit = 0.3)
  
}
feb20teamassocteamword

# Feb hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Feb freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$feb20 <- topic$terms
talkedtopicfreq$feb20 <- topic$freq

feb20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  feb20topicassocteamword[talkedtopic$feb20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$feb20[[i]], corlimit = 0.3)
}
feb20topicassocteamword







# Mar20
txtCorpus <- VCorpus(VectorSource(F_Mar2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Mar best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Mar freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$mar20 <- team$terms
talkedteamsfreq$mar20 <- team$freq

# word associate to team
mar20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  mar20teamassocteamword[talkedteams$mar20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$mar20[[i]], corlimit = 0.3)
  
}
mar20teamassocteamword

# Mar hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Mar freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$mar20 <- topic$terms
talkedtopicfreq$mar20 <- topic$freq

mar20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  mar20topicassocteamword[talkedtopic$mar20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$mar20[[i]], corlimit = 0.3)
}
mar20topicassocteamword








# Apr20
txtCorpus <- VCorpus(VectorSource(G_Apr2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Apr best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Apr freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=20)

aprteamlist <- head(frequencytable, n=20)
aprteamlist <- aprteamlist[-c(5,6),]
aprteamlist[1:10,]
talkedteams$apr20 <- aprteamlist$terms[1:10]
talkedteamsfreq$apr20 <- aprteamlist$freq[1:10]

# word associate to team
apr20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  apr20teamassocteamword[talkedteams$apr20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$apr20[[i]], corlimit = 0.3)
  
}
apr20teamassocteamword

# Apr hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Apr freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$apr20 <- topic$terms
talkedtopicfreq$apr20 <- topic$freq

apr20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  apr20topicassocteamword[talkedtopic$apr20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$apr20[[i]], corlimit = 0.3)
}
apr20topicassocteamword







# May20
txtCorpus <- VCorpus(VectorSource(H_May2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# May best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# May freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=20)

mayteamlist <- head(frequencytable, n=20)
mayteamlist <- mayteamlist[-c(2,7,11,13),]
mayteamlist[1:10,]
talkedteams$may20 <- mayteamlist$terms[1:10]
talkedteamsfreq$may20 <- mayteamlist$freq[1:10]

# word associate to team
may20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  may20teamassocteamword[talkedteams$may20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$may20[[i]], corlimit = 0.3)
  
}
may20teamassocteamword

# May hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# May freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$may20 <- topic$terms
talkedtopicfreq$may20 <- topic$freq

may20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  may20topicassocteamword[talkedtopic$may20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$may20[[i]], corlimit = 0.3)
}
may20topicassocteamword










# Jun20
txtCorpus <- VCorpus(VectorSource(I_June2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Jun best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Jun freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=20)

junteamlist <- head(frequencytable, n=20)
junteamlist <- junteamlist[-c(2,5,10,14),]
junteamlist[1:10,]
talkedteams$jun20 <- junteamlist$terms[1:10]
talkedteamsfreq$jun20 <- junteamlist$freq[1:10]

# word associate to team
jun20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  jun20teamassocteamword[talkedteams$jun20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$jun20[[i]], corlimit = 0.3)
  
}
jun20teamassocteamword


# Jun hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Jun freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$jun20 <- topic$terms
talkedtopicfreq$jun20 <- topic$freq

jun20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  jun20topicassocteamword[talkedtopic$jun20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$jun20[[i]], corlimit = 0.3)
}
jun20topicassocteamword







# Jul20
txtCorpus <- VCorpus(VectorSource(J_July2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Jul best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Jul freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$jul20 <- team$terms
talkedteamsfreq$jul20 <- team$freq

# word associate to team
jul20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  jul20teamassocteamword[talkedteams$jul20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$jul20[[i]], corlimit = 0.3)
  
}
jul20teamassocteamword

# Jul hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Jul freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$jul20 <- topic$terms
talkedtopicfreq$jul20 <- topic$freq

jul20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  jul20topicassocteamword[talkedtopic$jul20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$jul20[[i]], corlimit = 0.3)
}
jul20topicassocteamword






# Aug20
txtCorpus <- VCorpus(VectorSource(K_Aug2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Sug best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Aug freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$aug20 <- team$terms
talkedteamsfreq$aug20 <- team$freq

# word associate to team
aug20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  aug20teamassocteamword[talkedteams$aug20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$aug20[[i]], corlimit = 0.3)
  
}
aug20teamassocteamword

# Aug hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Aug freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$aug20 <- topic$terms
talkedtopicfreq$aug20 <- topic$freq

aug20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  aug20topicassocteamword[talkedtopic$aug20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$aug20[[i]], corlimit = 0.3)
}
aug20topicassocteamword







# Sep20
txtCorpus <- VCorpus(VectorSource(L_Sep2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Sep best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Sep freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$sep20 <- team$terms
talkedteamsfreq$sep20 <- team$freq

# word associate to team
sep20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  sep20teamassocteamword[talkedteams$sep20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$sep20[[i]], corlimit = 0.3)
  
}
sep20teamassocteamword

# Sep hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Sep freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$sep20 <- topic$terms
talkedtopicfreq$sep20 <- topic$freq

sep20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  sep20topicassocteamword[talkedtopic$sep20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$sep20[[i]], corlimit = 0.3)
}
sep20topicassocteamword







# Oct20
txtCorpus <- VCorpus(VectorSource(M_Oct2020$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Oct best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Oct20 freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=20)

octteamlist <- head(frequencytable, n=20)
octteamlist <- octteamlist[-c(7,11:13),]
octteamlist[1:10,]
talkedteams$oct20 <- octteamlist$terms[1:10]
talkedteamsfreq$oct20 <- octteamlist$freq[1:10]

# word associate to team
oct20teamassocteamword <- vector(mode="double")
for (i in 1:10){
  oct20teamassocteamword[talkedteams$oct20[[i]]] <- findAssocs(txtTdm, terms = talkedteams$oct20[[i]], corlimit = 0.3)
  
}
oct20teamassocteamword

# Oct20 hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Oct20 freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$oct20 <- topic$terms
talkedtopicfreq$oct20 <- topic$freq

oct20topicassocteamword <- vector(mode="double")
for (i in 1:10){
  oct20topicassocteamword[talkedtopic$oct20[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$oct20[[i]], corlimit = 0.3)
}
oct20topicassocteamword








# tweetbyteam
txtCorpus <- VCorpus(VectorSource(tweetbyteam$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# tweetbyteam best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# tweetbyteam freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=20)

tweetbyteamlist <- head(frequencytable, n=20)
tweetbyteamlist <- tweetbyteamlist[-c(6),]
tweetbyteamlist[1:10,]
talkedteams$tweetbyteam <- tweetbyteamlist$terms[1:10]
talkedteamsfreq$tweetbyteam <- tweetbyteamlist$freq[1:10]
tweetbyteamlist

# word associate to team
tweetbyteamassocteamword <- vector(mode="double")
for (i in 1:10){
  tweetbyteamassocteamword[talkedteams$tweetbyteam[[i]]] <- findAssocs(txtTdm, terms = talkedteams$tweetbyteam[[i]], corlimit = 0.3)
  
}
tweetbyteamassocteamword

# tweetbyteam hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# tweetbyteam freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$tweetbyteam <- topic$terms
talkedtopicfreq$tweetbyteam <- topic$freq

tweetbyteeamtopicassocteamword <- vector(mode="double")
for (i in 1:10){
  tweetbyteeamtopicassocteamword[talkedtopic$tweetbyteam[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$tweetbyteam[[i]], corlimit = 0.3)
}
tweetbyteeamtopicassocteamword








# total
txtCorpus <- VCorpus(VectorSource(total$text))
# without team names in the stop words
bestteam <- cleanCorpus(txtCorpus, stops)
#with team names in the stop words
hittopic <- cleanCorpus(txtCorpus, stopswteamnames)

# Total best team
txtTdm  <- TermDocumentMatrix(bestteam)
txtTdmM <- as.matrix(txtTdm)

# Total freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

team <- head(frequencytable, n=10)
talkedteams$total <- team$terms
talkedteamsfreq$total <- team$freq

totalteamlist$team <- frequencytable$terms
totalteamlist$teamfreq <- frequencytable$freq

# word associate to team
totalteamassocteamword <- vector(mode="double")
for (i in 1:10){
  totalteamassocteamword[talkedteams$total[[i]]] <- findAssocs(txtTdm, terms = talkedteams$total[[i]], corlimit = 0.3)
  
}
totalteamassocteamword

# Total hittopic
txtTdm  <- TermDocumentMatrix(hittopic, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

# Total freq
frequency <- rowSums(txtTdmM)
frequency <- data.frame(terms = rownames(txtTdmM), freq = frequency)
rownames(frequency) <- NULL
frequencytable <- frequency[order(frequency$freq, decreasing = T),]
head(frequencytable, n=10)

topic <- head(frequencytable, n=10)
talkedtopic$total <- topic$terms
talkedtopicfreq$total <- topic$freq

totaltopiclist$topic <- frequencytable$terms
totaltopiclist$topicfreq <- frequencytable$freq

totaltopicassocteamword <- vector(mode="double")
for (i in 1:10){
  totaltopicassocteamword[talkedtopic$total[[i]]] <-findAssocs(txtTdm, terms = talkedtopic$total[[i]], corlimit = 0.3)
}
totaltopicassocteamword



# Review
head(talkedteams)
head(talkedtopic)
head(totaltopiclist)
head(totalteamlist)
head(talkedteamsfreq)
head(talkedtopicfreq)

talkedteamsDF <- data.frame(talkedteams)
talkedtopicDF <- data.frame(talkedtopic)
totalteamlistDF <- data.frame(totalteamlist)
totaltopiclistDF <- data.frame(totaltopiclist)
talkedteamsfreqDF <- data.frame(talkedteamsfreq)
talkedtopicfreqDF <- data.frame(talkedtopicfreq)

head(talkedteamsDF)
head(talkedtopicDF)
head(talkedteamsfreqDF)
head(talkedtopicfreqDF)
head(totalteamlistDF)
head(totaltopiclistDF)
talkedteamsDF
# Graph preparation
keyword <- c("lakers", "heat", "raptors", "rockets", "celtics", "warriors")

teamfreqrowindex <- data.frame(matrix(ncol = 6, nrow = 15),stringsAsFactors = FALSE)
for (x in seq_along(keyword)){
  coltemplocation <- vector(length = 15, mode = "double")
  for(i in seq_along(talkedteamsDF)){
    temphold <- which(talkedteamsDF[,i] %in% keyword[x])
    if(length(temphold) > 0){
      coltemplocation[i] <- temphold
    } else{
      temphold <- 0
    }
  }
  teamfreqrowindex[,keyword[x]] <- coltemplocation
}

teamfreqrowindex <- teamfreqrowindex[,7:12]
rownames(teamfreqrowindex) <- names(talkedteamsDF)
teamfreqrowindex

top6teamstalkedfreq <- data.frame(matrix(ncol = 6, nrow = 15),stringsAsFactors = FALSE)
for(x in seq_along(keyword)){
  colno <- 1
  coltemplocation <- vector(length = 15, mode = "double")
  for(i in teamfreqrowindex[,x]){
    temphold <- talkedteamsfreqDF[i,colno]
    if(length(temphold) > 0){
      coltemplocation[colno] <- temphold
    } else{
      temphold <- 0
    }
    colno <- colno+1
  }
  top6teamstalkedfreq[,keyword[x]] <- coltemplocation
}

top6teamstalkedfreq <- top6teamstalkedfreq[7:12]
rownames(top6teamstalkedfreq) <- names(talkedteamsDF)
top6teamstalkedfreq
actualtotalteamfreqsum <- top6teamstalkedfreq[15,1:6]
actualtotalteamfreqsum

total_sum <- data.frame(matrix(ncol = 6, nrow = 1),stringsAsFactors = FALSE)
for(i in seq_along(keyword)) {
  total_sum[i] <- sum(top6teamstalkedfreq[1:13,i])
}
colnames(total_sum) <- keyword
rownames(total_sum) <- "total"
total_sumDF <- data.frame(t(total_sum))
total_sumDF$team <-rownames(total_sumDF)
total_sumDF

top6teamstalkedfreq[15,1:6] <- total_sum
top6teamstalkedfreq



talkedteamgraph <- data.frame(matrix(ncol = 3, nrow = 78),stringsAsFactors = FALSE)
r <- 1
for(x in seq_along(keyword)){
  temp <- vector(mode = "double")
  tempdate <- vector(mode = "double")
  for(n in 1:13){
    temp[n] <- keyword[x]
    tempdate[n] <- rownames(top6teamstalkedfreq)[n]
  }
  talkedteamgraph[r:c(r+12),1] <- temp
  talkedteamgraph[r:c(r+12),2] <- tempdate
  talkedteamgraph[r:c(r+12),3] <- top6teamstalkedfreq[1:13,x]
  r <- r + 13
}
colnames(talkedteamgraph) <- c("team", 'date', 'freq')
head(talkedteamgraph)

# change the data type from character to yearmon
talkedteamgraph$date
talkedteamgraph$date <- as.yearmon(talkedteamgraph$date, "%b%y")



# topic associate word
oct19topicassocteamword
nov19topicassocteamword
dec19topicassocteamword
jan20topicassocteamword
feb20topicassocteamword
mar20topicassocteamword
apr20topicassocteamword
may20topicassocteamword
jun20topicassocteamword
jul20topicassocteamword
aug20topicassocteamword
sep20topicassocteamword
oct20topicassocteamword
totaltopicassocteamword
tweetbyteeamtopicassocteamword


# Graph

# color platter
display.brewer.all()
blues <- brewer.pal(8, "Blues")
blues <- blues[-c(1:2)]

GnBu <- brewer.pal(8, "GnBu")
GnBu <- GnBu[-c(1:2)]
GnBu


# Graph 1 - Top 6 most mentioned team by years
talkedteamgraph %>% 
  ggplot(data=., aes(x=date, y=freq,color = team))+
  geom_line(size=1)+
  xlab("Date") + ylab("Mentioned frequency") +
  ggtitle("Top 6 most mentioned team by years") +
  theme(plot.title = element_text(hjust = 0.5))



# Graph 2 - Top 6 most mentioned team by total
total_sumDF%>%
  ggplot(data=.,aes(x=reorder(team,total),total))+
  geom_bar(stat = "identity", fill = blues)+
  xlab("Team name") + ylab("Mentioned frequency") +
  ggtitle("Top 6 most mentioned team by total") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_text(aes(label = total), size = 3, position = position_stack(vjust = 0.5))



# Graph 3 - Lakers associated words Oct20
txtCorpus <- VCorpus(VectorSource(M_Oct2020$text))
txtCorpus <- cleanCorpus(txtCorpus, stops)
txtTdm  <- TermDocumentMatrix(txtCorpus, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

exampleTweet <- grep('lakers', rownames(txtTdmM))
txtTdmv <- sort(rowSums(txtTdmM), decreasing = TRUE)
txtTdmDF   <- data.frame(word = names(txtTdmv), freq = txtTdmv)
Lakers_Oct20 <- txtTdmDF[1:50,]

wordcloud(txtTdmDF$word,
          txtTdmDF$freq,
          max.words    = 50,
          random.order = FALSE,
          colors       = blues,
          scale        = c(2,1))

# Graph 4 - Lakers associated words Nov19
txtCorpus <- VCorpus(VectorSource(B_Nov2019$text))
txtCorpus <- cleanCorpus(txtCorpus, stops)
txtTdm  <- TermDocumentMatrix(txtCorpus, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

exampleTweet <- grep('lakers', rownames(txtTdmM))
txtTdmv <- sort(rowSums(txtTdmM), decreasing = TRUE)
txtTdmDF   <- data.frame(word = names(txtTdmv), freq = txtTdmv)
Lakers_Nov19 <- txtTdmDF[1:50,]

wordcloud(txtTdmDF$word,
          txtTdmDF$freq,
          max.words    = 50,
          random.order = FALSE,
          colors       = GnBu,
          scale        = c(1,1))


# Graph 5 - Lakers nov19 oct20 bar comparision
Lakers_Nov19[1:10,]%>%
  ggplot(data=.,aes(x=reorder(word,freq),freq))+
  geom_bar(stat = "identity", fill = Greens[5])+
  xlab("Associated words") + ylab("Mentioned frequency") +
  ggtitle("Nov 19") +
  theme(plot.title = element_text(hjust = 0.5)) 


# Graph 6 - Lakers nov19 oct20 bar comparision
Lakers_Oct20[1:10,]%>%
  ggplot(data=.,aes(x=reorder(word,freq),freq))+
  geom_bar(stat = "identity", fill = blues[5])+
  xlab("Associated words") + ylab("Mentioned frequency") +
  ggtitle("Oct 20") +
  theme(plot.title = element_text(hjust = 0.5)) 




# Graph 7 - warriors associated words 
txtCorpus <- VCorpus(VectorSource(D_Jan2020$text))
txtCorpus <- cleanCorpus(txtCorpus, stops)
txtTdm  <- TermDocumentMatrix(txtCorpus, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

exampleTweet <- grep('warriors', rownames(txtTdmM))
txtTdmv <- sort(rowSums(txtTdmM), decreasing = TRUE)
txtTdmDF   <- data.frame(word = names(txtTdmv), freq = txtTdmv)
Warriors_Jan20 <- txtTdmDF[1:50,]

txtCorpus <- VCorpus(VectorSource(E_Feb2020$text))
txtCorpus <- cleanCorpus(txtCorpus, stops)
txtTdm  <- TermDocumentMatrix(txtCorpus, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

exampleTweet <- grep('warriors', rownames(txtTdmM))
txtTdmv <- sort(rowSums(txtTdmM), decreasing = TRUE)
txtTdmDF   <- data.frame(word = names(txtTdmv), freq = txtTdmv)
Warriors_Feb20 <- txtTdmDF[1:50,]

Warriors_Jan20[1:10,]%>%
  ggplot(data=.,aes(x=reorder(word,freq),freq))+
  geom_bar(stat = "identity", fill = Greens[5])+
  xlab("Associated words") + ylab("Mentioned frequency") +
  ggtitle("Jan 20") +
  theme(plot.title = element_text(hjust = 0.5)) 


Warriors_Feb20[1:10,]%>%
  ggplot(data=.,aes(x=reorder(word,freq),freq))+
  geom_bar(stat = "identity", fill = blues[5])+
  xlab("Associated words") + ylab("Mentioned frequency") +
  ggtitle("Feb 20") +
  theme(plot.title = element_text(hjust = 0.5)) 


# Graph 8
a <- data.frame(matrix(ncol = 2, nrow = 130),stringsAsFactors = FALSE)
b <- vector(mode = "double")
n <- 1
for(x in 1:13){
for(i in 1:10){
  a[n,1] <- talkedtopic[[x]][i] 
  b <- length(grep(talkedtopic[[x]][i], talkedtopic))
  if(length(b)>0){
    a[n,2]<-b
  } else{
    a[n,2]<-0
  }
  n <- n+1
}
}
colnames(a)<- c('terms','freq')

a$dupes <- duplicated(a)
head(a)
a <- subset(a, a$dupes != TRUE)

a <- a %>% 
    arrange_at(2, desc)

a[1:10,]%>%
  ggplot(data=.,aes(x=reorder(terms,freq),freq))+
  geom_bar(stat = "identity", fill = blues[5])+
  xlab("Associated words") + ylab("Mentioned frequency") +
  ggtitle("Trendy topics") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_text(aes(label = freq), size = 3, position = position_stack(vjust = 0.5))



# NIKE bar chart
txtCorpus <- VCorpus(VectorSource(total$text))
txtCorpus <- cleanCorpus(txtCorpus, stops)
txtTdm  <- TermDocumentMatrix(txtCorpus, control=list(tokenize=bigramTokens))
txtTdmM <- as.matrix(txtTdm)

exampleTweet <- grep('nike', rownames(txtTdmM))
txtTdmv <- sort(rowSums(txtTdmM), decreasing = TRUE)
txtTdmDF   <- data.frame(word = names(txtTdmv), freq = txtTdmv)
nike<- txtTdmDF[1:50,]

wordcloud(txtTdmDF$word,
          txtTdmDF$freq,
          max.words    = 50,
          random.order = FALSE,
          colors       = blues,
          scale        = c(2,1))

nike[1:10,]%>%
  ggplot(data=.,aes(x=reorder(word,freq),freq))+
  geom_bar(stat = "identity", fill = blues[5])+
  xlab("Associated words") + ylab("Mentioned frequency") +
  ggtitle("Trendy topics") +
  theme(plot.title = element_text(hjust = 0.5)) +
  geom_text(aes(label = freq), size = 3, position = position_stack(vjust = 0.5))
