# 安裝套件
library(GISTools)
library(rgdal)

# 讀取檔案（地圖）
setwd("/Users/zhaowen/Desktop/Data-Science/mapdata201906180922")
map <- readOGR(dsn = ".", layer = "TOWN_MOI_1080617", encoding = "unicode")

# 讀取檔案（生育率）
setwd("/Users/zhaowen/Desktop/Data-Science")
Birth <- read.csv("Birth_rate103-107.csv")
Marry <- read.csv("Marriage_rate103-107.csv")

# 整理出
library(dplyr)
All <- cbind(Birth, Marry)
All <- All[,-c(13,14)]
All_107 <- filter(All, year=="107年") %>%
  slice(2:13)

setwd("/Users/zhaowen/Desktop/Data-Science/mapdata201906180922")
map.df <- map@data
map.df <- arrange(map.df, TOWNID)%>%
  slice(1:12)
map_taipei <- cbind(map.df, All_107)
map_taipei<- map_taipei[,-c(8,9)]
map@data <- map_taipei
head(map@data, 2)

birth_107 = All_107$"育齡婦女一般生育率" 
library(ggplot2)
head(map$TOWNNAME)
map.df <- fortify(map, region = "TOWNNAME") %>%
  rename(map.df,TOWNNAME=id)
head(map.df, 10)
map.df <- filter(map.df, TOWNNAME %in% c("松山區", "信義區", "大安區", "中山區", "中正區", "大同區", "萬華區", "文山區", "南港區", "內湖區", "士林區", "北投區"))
head(map.df, 10)

All_107 <- rename(All_107, TOWNNAME=location)
birth_107 = All_107$"育齡婦女一般生育率" 
head(birth_107)
final.plot <- outer(birth_107, map.df, by=TOWNNAME)
head(final.plot,10)

library(RColorBrewer)
twcmap<-ggplot() +
  geom_polygon(data = final.plot, 
               aes(x = long, y = lat, group = group, 
                   fill = birthrate), 
               color = "black", size = 0.25) + 
  coord_map()+
  scale_fill_gradientn(colours = brewer.pal(9,"Reds"))+
  theme_void()+
  labs(title="Birthrate of Taipei in Taiwan")
twcmap
