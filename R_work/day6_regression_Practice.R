# https://kbig.kr/edu_manual/html/prod_update/basic/product_chapter_1.html
setwd("/Users/yoon/Documents/DataScience/R_work") 
# library1 <- c("plyr", "ggplot2", "stringr", "zoo", "corrplot", "RColorBrewer")
# unlist(lapply(library1, require, character.only=TRUE))
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

product <- read.csv("product_2015_data/product.csv", header=T, sep=",", fileEncoding="UTF-8")
code <- read.csv("product_2015_data/code.csv", header=T, sep=",", fileEncoding="UTF-8")
weather <- read.csv("product_2015_data/weather.csv", header=T, sep=",", fileEncoding="UTF-8")

### 전처리작업
summary(product)
str(product)
summary(weather)
colnames(product) <- c('date','category','item','region','mart','price')
category <- subset(code, code$구분코드설명=="품목코드")
colnames(category) <- c('code', 'exp', 'item', 'name')

total.pig <-product[which(product$item==514),] # 돼지고기 먹방완료
region <- subset(code, code$구분코드설명=="지역코드") # 지역코드 추출 완료
