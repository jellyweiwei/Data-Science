# 檔案匯入
getwd()
setwd("/Users/zhaowen/Desktop/Data-Science/Week3_期末專題")

library(readr)

r_t <- read.csv("/Users/zhaowen/Desktop/Data-Science/Week3_期末專題/降雨量-颱風.csv")
hurt <- read.csv("/Users/zhaowen/Desktop/Data-Science/Week3_期末專題/颱風傷亡.csv")

library(readxl)

sp <- read_excel("/Users/zhaowen/Desktop/Data-Science/Week3_期末專題/2000.xlsx")

sp1 <- as.data.frame(sp)


# 總計df
library(dplyr)

levels(hurt$name)[63] <- "山竹"

#改col名稱
colnames(r_t)[2]="name"

rt.hurt <- merge(r_t, hurt, by="name")
rh <- arrange(rt.hurt, X)
rh1 <- rh[-c(3, 5, 9, 11, 12, 16, 19, 22, 26, 34,35, 40, 41, 46, 47, 49, 53, 56, 57, 59, 61, 66, 68, 72, 75, 83, 87, 92, 93, 97, 99, 102, 103, 108,111, 116, 121, 124, 129, 133, 135, 137),]

rh2 <- rh1[-c(1,2),]

colnames(rh2)[5]="wind"

rh2$cas.total <- as.numeric(rh2$cas.total)

##整理路徑
colnames(sp1)[1]="name"
colnames(sp1)[2]="path"
sp2 <- select(sp1, "name", "path")



# 畫圖
library(ggplot2)

## 雨量-風速
ggplot(rh2, aes(x = average, y = wind)) + geom_point() 

## 雨量平均-風速-傷亡
qplot(average, wind, data = rh2, size = cas.total, alpha = I(0.7))

## 高於平均雨量-風速-傷亡
qplot(better_than_average, wind, data = rh2, size = cas.total, alpha = I(0.7))

## 警戒值level1-風速-傷亡
qplot(level_1, wind, data = rh2, size = cas.total, alpha = I(0.7))

## 警戒值level2-風速-傷亡
qplot(level_2, wind, data = rh2, size = cas.total, alpha = I(0.7))



