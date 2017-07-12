setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(plyr); library(ggplot2); library(stringr); library(zoo);  library(TSclust)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

pig.region <- read.csv("pig.region.csv", header=T, sep=",", fileEncoding="UTF-8")
month.item.mean <- read.csv("month.item.mean.csv", header=T, sep=",", fileEncoding="UTF-8")
date.item.mean <- read.csv("date.item.mean.csv", header=T, sep=",", fileEncoding="UTF-8")

library(plyr)
temp <- split(date.item.mean, date.item.mean$name)
farm.product <- data.frame(쌀=temp$쌀$price.mean,   배추=temp$배추$price.mean,
                             상추=temp$상추$price.mean, 호박=temp$호박$price.mean,  
                             양파=temp$양파$price.mean, 파프리카=temp$파프리카$price.mean,
                             참깨=temp$참깨$price.mean, 사과=temp$사과$price.mean)

# 자료에는 plot(hclust(diss(farm.product,"COR")), axes = F, ann = F)
# 라는 코드로 플롯을 생성했지만, 클러스터링에 대한 명확한 기준도 없고, 이상해보여서 다시 해보았다.
corr <- cor(farm.product)
d <- dist(corr)
h <- hclust(d)
plot(h, family="AppleGothic")
# 시계열 가격 연관성을 척도로 클러스터링을하였는데, 
# 자료에서도 아마 이걸 하려던 것 같은데 뭐가 맞는지는 모르겠다.

ggplot(month.item.mean[month.item.mean$name %in% c("상추", "호박", "파프리카"),],
       aes(x=month, y=price.mean, colour=name, group=name)) + geom_line() +
theme_bw() + geom_point(size=6, shape=20, alpha=0.5) +
ylab("가격") + xlab("") + theme_bw(base_family = "AppleGothic")