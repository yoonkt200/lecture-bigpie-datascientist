# https://kbig.kr/edu_manual/html/prod_update/basic/product_chapter_1.html
setwd("/Users/yoon/Documents/DataScience/R_work") 
library1 <- c("plyr", "ggplot2", "stringr", "zoo", "corrplot", "RColorBrewer")
library(plyr); library(ggplot2); library(stringr); library(zoo); library(corrplot); library(RColorBrewer)
unlist(lapply(library1, require, character.only=TRUE))
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
str(region)

colnames(region) <- c('code', 'exp', 'region', 'name')
day.pig <- merge(total.pig, region, by="region", all=T) # 지역별 돼지고기 먹방완료

# day.pig 데이터를 일별로 정렬한 후, 
# 지역별로 돼지고기의 평균가격을 구하여 생성한 데이터 프레임을 지역별 이름으로 나누어 
# total.pig.mean이라는 리스트 형태의 데이터를 생성한다
total.pig.mean <- dlply(ddply(ddply(day.pig, .(date), summarise, name=name, region=region, price=price),.(date, name), summarise, mean.price=mean(price)), .(name))
total.pig.mean$수원

library(doBy)
total.pig.mean = summaryBy(price~date+name, day.pig, FUN = mean)
# 위랑 똑같은 방법. 이게 훨씬 간단

a2 = splitBy(~name, total.pig.mean)
a2

install.packages('dplyr')
library(dplyr)

arrange(day.pig, name, desc(date)) # data sort
day.pig  <- day.pig [! day.pig$name %in% c("의정부","용인","창원","안동","포항","순천","춘천" ),] # data except


### 날짜데이터 전처리 관련
dd1 = day.pig$date[1:10]
str(dd1)

dd2 = as.Date(dd1)
str(dd2)

dd3=gsub('[-]', '.', dd1)
str(dd3)

str(format(dd2, "%Y-%m-%d")) # return character type

# install.packages("lubridate")
library(lubridate)
dd4 = ymd(20121223) # 어떤 포맷이 들어가도 데이트 형태로 만들어줌
dd4 = ymd(dd3)

year(dd4)
months(dd4)

#### %>% : R에서의 연속연산자

### 여러가지 방법으로 전처리

day.pig$date = ymd(day.pig$date)
day.pig$date_month = months(ymd(day.pig$date))
day.pig$date_year = year(ymd(day.pig$date))

# 지역, 일별 평균 돼지고기 가격
pig.region.daily.mean = summaryBy(price~date+name, day.pig, FUN = mean)
# 지역, 월별 평균 돼지고기 가격
pig.region.monthly.mean = summaryBy(price~date_month+name, day.pig, FUN = mean)
# 지역, 년별 평균 돼지고기 가격
pig.region.yearly.mean = summaryBy(price~date_year+name, day.pig, FUN = mean)


#### 여기까지 데이터 핸들링 끝


library(ggplot2)
ggplot(pig.region.monthly.mean, aes(x=date_month, y=price.mean, colour=name, group=name)) +
geom_line() + theme_bw() + geom_point(size=6, shape=20, alpha=0.5) +
ylab("돼지고기 가격") + xlab("") + theme_bw(base_family = "AppleGothic") 
# mac 에서 ggplot font 깨짐 문제 해결방법 : theme_bw(base_family = "AppleGothic") 추가하면해결.

library(plyr)
city1 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="서울 ")
city2 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="부산")
city3 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="대구")
city4 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="인천")
city5 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="광주")
city6 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="대전")
city7 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="울산")
city8 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="수원")
city9 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="청주")
city10 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="전주")
city11 = subset(pig.region.daily.mean, pig.region.daily.mean$name=="제주")

pig.region <- data.frame(서울=city1$price.mean,  부산=city2$price.mean,
                           대구=city3$price.mean, 인천=city4$price.mean, 광주=city5$price.mean,
                           대전=city6$price.mean, 울산=city7$price.mean, 수원=city8$price.mean,
                           청주=city9$price.mean, 전주=city10$price.mean, 제주=city11$price.mean)
cor_pig <- cor(pig.region)
corrplot(cor_pig, method="color", type="upper", order="hclust", addCoef.col = "white", tl.srt=0, tl.col="black", tl.cex=0.7, col=brewer.pal(n=8, name="PuOr"), family = "AppleGothic")
