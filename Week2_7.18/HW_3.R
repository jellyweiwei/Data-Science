# 1. 收集一份文本
## 資料來源：http://www.txttw.com/forum.php?mod=viewthread&tid=62698&highlight=禁咒師
library(tm)
seba <- VCorpus(DirSource(directory ="/Users/zhaowen/Desktop/Data-Science/data/txt",encoding = "UTF-8"))
inspect(seba[1:2])
identical(seba[[1]], seba[["禁咒師.txt"]])


# 2. 文字清洗
seba <- tm_map(seba, stripWhitespace)
seba <- tm_map(seba, removeNumbers)
seba <- tm_map(seba, removePunctuation)
seba <- tm_map(seba, tolower)
seba <- tm_map(seba, function(word) {
  gsub("[A-Za-z0-9]", "", word)
})

# 3. 斷詞
library(tmcn)
words <- c("明峰", "蕙娘", "英俊", "麒麟", "末日")
insertWords(words)
seba <- tm_map(seba, segmentCN, nature = TRUE) 

seba <- tm_map(seba, function(sentence) {
  noun <- lapply(sentence, function(w) {
    w[names(w) == "n"]
  })
  unlist(noun)
})

myStopwords <- c(stopwordsCN(), "著", "、") #自定義庭用詞
seba <- tm_map(seba, removeWords, myStopwords)

for(i in seq(seba)){
  seba[[i]]<-gsub("/"," ",seba[[i]])
  seba[[i]]<-gsub("@"," ",seba[[i]])
  seba[[i]]<-gsub("-"," ",seba[[i]])
}

seba <- tm_map(seba, tolower)
seba <- tm_map(seba, PlainTextDocument)

# 4. 製作tdm
tdm <- TermDocumentMatrix(seba, control = list(wordLengths = c(2, Inf)))
m1 <- as.matrix(tdm)
v <- sort(rowSums(m1), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)



# 4. 詞的出現頻率（Bar charts）
library(dplyr)
df <- filter(d, freq >= 100)
library(RColorBrewer)
library(ggplot2)
library(forcats)
ggplot(data = df, mapping = aes(x = reorder(word, freq), y = freq, fill= freq)) + 
  geom_bar(stat= "identity")+
  theme(text=element_text(family="黑體-繁 中黑", size=10))+
  labs(x="文字", y="出現次數")+
  coord_flip()

# 5. 製作文字雲
library(wordcloud)
m1 <- as.matrix(tdm)
v <- sort(rowSums(m1), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
par(family=("Heiti TC Light"))
wordcloud(d$word, d$freq, min.freq = 50, random.order = F, ordered.colors = F, 
          colors = rainbow(length(row.names(m1))))

