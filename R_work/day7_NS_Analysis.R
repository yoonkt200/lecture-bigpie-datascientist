setwd("/Users/yoon/Documents/DataScience/R_work") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌
library(plyr); library(ggplot2); library(stringr); library(zoo); library(corrplot); library(gridExtra); library(urca)

product <- read.csv("product_2015_data/product.csv", header=T, sep=",", fileEncoding="UTF-8")
code <- read.csv("product_2015_data/code.csv", header=T, sep=",", fileEncoding="UTF-8")

colnames(product) <- c('date','category','item','region','mart','price')

# 품목과 일자별로 평균을 구함
temp = summaryBy(price~item+date, product, FUN = mean) # 1번 방법
# temp <- ddply(product, .(item, date), summarise, mean.price=mean(price)) : 2번 방법

category <- subset(code, code$구분코드설명=="품목코드")
colnames(category) <- c('code', 'exp', 'item', 'name')
date.item.mean <- merge(temp, category, by="item") # temp에다가 카테고리 정보를 merge함.

# 월간 평균값으로 데이터를 파생
library(lubridate)
date.item.mean$month <- paste(year(ymd(temp$date)), gsub("월", "", months(ymd(temp$date))), sep = "-")
month.item.mean <- summaryBy(price.mean~month+name+item, date.item.mean, FUN = mean)
colnames(month.item.mean) <- c("month", "name", "item", "price.mean")
# month.item.mean <- ddply(date.item.mean, .(name, item, month=str_sub(as.character.Date(date),1,7)), summarise, mean.price=mean(mean.price))
# : 2번 방법

# 일간 품목별 평균값을 나타내는 데이터
date.item.mean$name
date.item.mean <- droplevels(date.item.mean) # date.item.mean의 name의 level중 쓰레기값 제거(안쓰는데 들어온 애들이 있음)
date.item.mean$name
temp <- split(date.item.mean, date.item.mean$name)
str(temp)

daily.product <- data.frame(쌀=temp$쌀$price.mean,   배추=temp$배추$price.mean,
                             상추=temp$상추$price.mean, 호박=temp$호박$price.mean,  
                             양파=temp$양파$price.mean, 파프리카=temp$파프리카$price.mean,
                             참깨=temp$참깨$price.mean, 사과=temp$사과$price.mean,
                             돼지고기=temp$돼지고기$price.mean,   닭고기=temp$닭고기$price.mean)

# 월간 품목별 평균값 데이터
month.item.mean$name
month.item.mean <- droplevels(month.item.mean)
temp <- split(month.item.mean, month.item.mean$name)
monthly.product <- data.frame(쌀=temp$쌀$price.mean,   배추=temp$배추$price.mean,
                               상추=temp$상추$price.mean, 호박=temp$호박$price.mean,  
                               양파=temp$양파$price.mean, 파프리카=temp$파프리카$price.mean,
                               참깨=temp$참깨$price.mean, 사과=temp$사과$price.mean,
                               돼지고기=temp$돼지고기$price.mean,   닭고기=temp$닭고기$price.mean)

# 공적분 검정
for (i in 1:9){
  for (j in 1:9){
    if ((i+j) < 11){
      jc <- ca.jo(data.frame(daily.product[,i], daily.product[,i+j]), type="trace", K=2, ecdet="const")
      if (jc@teststat[1] > jc@cval[1]){
        if (jc@V[1,1]*jc@V[2,1]>0){
          cat(colnames(monthly.product)[i],"와" , colnames(monthly.product)[i+j], ": 음의 공적분 관계가 있다.", "\n")
        } else {
          cat(colnames(monthly.product)[i],"와" , colnames(monthly.product)[i+j], ": 양의 공적분 관계가 있다.","\n")
        }
      }
    }
  }
}