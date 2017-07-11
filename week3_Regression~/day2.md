# 2일차 


-----------------------


#### **1. 데이터 전처리 실제 데이터 적용**


> **1.1 **

- 실제 공공데이터를 이용하여 데이터 전처리과정을 거친 후 시각화까지 실행해보았음.

- 다음 링크의 과정을 연습해 본 것으로, 누구나 접속이 가능.

- https://kbig.kr/edu_manual/html/prod_update/basic/product_chapter_2.html

```R
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
date.item.mean$month <- str_sub(as.character.Date(temp$date),1,7)
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

# 시계열 데이터 비교 시각화 그래프
p1 <- ggplot(month.item.mean[month.item.mean$name %in% c("돼지고기", "상추"),], aes(x=month, y=price.mean, colour=name, group=name)) +
geom_line() + scale_y_continuous(name="가격",limits=c(0,2500)) +
theme_bw() + xlab("") + theme_bw(base_family = "AppleGothic") 

p1 + theme(legend.position="top") + scale_color_manual(values=c("red", "orange")) +
geom_line(size=1.0) + theme_bw(base_family = "AppleGothic") + scale_x_date()
```

-----------------------


#### **2. 시계열 데이터 분석**

> **2.1 공적분 검정**

- 두 시계열 데이터간의 연관성 분석을 위해 사용하는 검정 방식 중 하나이다.

- 주로 금융 데이터에서 사용하는 방법인데, 대략적인 개념은 다음과 같다.

```
물가나 주가같은 변동성이 심한 시계열 데이터는, 상관관계를 규정하기 어렵다.

이러한 데이터에서는 서로 연관되어 있는 변수들이 우연히 같이 증가하는 등의 상황이 자주 발생한다.

이러한 착시현상에 대한 올바른 검정방법이 공적분 검정이다.

이를 위해 여러가지 수정 모형이 선행되지만(단위근 검정 등),

중요한 것은 공적분 검정을 통하여 단기, 장기적인 시계열 데이터의 인과관계 추정이 가능하다는 것이다.

> 예를 들어 두 시계열 데이터 X1, X2가 있다고 하자.
> 이때 적당한 상수 a, b가 있고, 관계식 $aX1 + bX2 ~ 0$ 이 성립한다.
> 이 상황에서 두 시계열은 공적분 관계가 있다는 것을 의미한다.
> 만약 두 상수가 부호가 같다면 음의 공적분(서로 다른 방향의 움직임)
> 부호가 다르다면 음의 공적분(서로 같은 방향의 움직임)을 의미하게 된다.

이론적인 개념은 다음과 같고, R에서는 urca라는 라이브러리를 통해 공적분 검정을 시행할 수 있다.

R에서는 요한슨 공적분 검정 방정식을 사용하는데,

이론적으로 이 이상 깊게 들어간다면, 통계학자가 되버리므로.. 자세한 설명은 링크에 남긴다.

http://blog.naver.com/PostView.nhn?blogId=yonxman&logNo=220904870137
https://datascienceschool.net/view-notebook/d5478c5ed2044cb9b88fa2ef015eb3a4/
```

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/2.png)

#### 다음과 같은 시계열 데이터가 있다고 할때의 간단한 예제코드이다.

```R
library(urca)

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

# 상추 와 호박 : 양의 공적분 관계가 있다. 
# 상추 와 사과 : 음의 공적분 관계가 있다. 
# 상추 와 돼지고기 : 양의 공적분 관계가 있다. 
# 상추 와 닭고기 : 음의 공적분 관계가 있다. 
# 호박 와 닭고기 : 음의 공적분 관계가 있다. 
# 사과 와 닭고기 : 음의 공적분 관계가 있다. 
```