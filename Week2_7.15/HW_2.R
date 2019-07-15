#load data
setwd("/Users/zhaowen/Desktop/Data-Science")
Birth <- read.csv("Birth_rate103-107.csv")
Marry <- read.csv("Marriage_rate103-107.csv")

#see origin data
head(Birth)
head(Marry)

#install packages dplyr
library(dplyr)
All <- cbind(Birth, Marry)

#Tidy Data
All <- All[,-c(13,14)]

#see All
head(All)