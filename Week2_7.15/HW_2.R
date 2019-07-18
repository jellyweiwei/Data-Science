# **Search Data**
## 1.load data

setwd("/Users/zhaowen/Desktop/Data-Science/data")
Birth <- read.csv("Birth_rate103-107.csv")
Marry <- read.csv("Marriage_rate103-107.csv")



## 2.see origin data

head(Birth)
head(Marry)



## 3.install packages dplyr

library(dplyr)
All <- cbind(Birth, Marry)



## 4.Tidy Data

All <- All[,-c(13,14)]



## 5.see All

head(All)




#**Make a Map**
## 1.input shape files

setwd("/Users/zhaowen/Desktop/Data-Science/data")
library(maptools)
Ad.shp <- readShapeSpatial("TOWN_MOI_1080617.shp")



## 2.select administration in taipei

Ad.taipei <- Ad.shp[which(Ad.shp@data$COUNTYNAME == "臺北市"), ]
names(Ad.taipei)
print(Ad.taipei$TOWNNAME)



## 3.create data plot on map

Ad.num <- length(Ad.taipei$TOWNNAME)
mydata <- data.frame(Ad.taipei$TOWNNAME, id=(1:Ad.num), prevalence = rnorm(Ad.num, 55, 5))
head(mydata, 12)



## 4.fortify shapefile to get into dataframe

Ad.taipei.df <- fortify(Ad.taipei, region = "TOWNID")
class(Ad.taipei.df)
head(Ad.taipei.df,12)



## 5.merge to map & data gether
merged_data <- merge(mydata, Ad.taipei.df, by="id", all.x=TRUE)
head(merged_data)
final.plot <- merged_data[order(merged_data$), ]

## 6.basic plot

ggplot()+
  geom_polygon(data = final.plot,
               aes(x = long, y = lat, group = group, fill = prevalence),
               color = "black", size = 0.25) +
  coord_map()




#**Bar Chart Test**
## 1.data in

library(dplyr)
birth_bar <- All %>%
  select(year, location, 育齡婦女一般生育率) %>%
  filter(year %in% c("107年"))



## 2.bar chart

ggplot(data = birth_bar,
       aes(x=location,
           y=育齡婦女一般生育率,
           fill="育齡婦女一般生育率"))+
  geom_bar(stat="identity")




#**Line Chart Test**
## 1.data in

library(ggplot2)
birth_line <- All %>%
  select(year, location, 育齡婦女一般生育率) %>%
  filter(location %in% c("總計"))
head(birth_line)



## 2.line chart

ggplot(data = birth_line,
       aes(x= "year", 
           y= "育齡婦女一般生育率",
           group=1))+
  geom_line()+
  geom_point()