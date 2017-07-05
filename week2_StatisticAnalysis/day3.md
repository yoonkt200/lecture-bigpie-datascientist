# 3일차 


-----------------------


#### **1. 데이터 조작**


> **1.1 데이터 생성 및 저장**

```R

setwd("/Users/yoon/Documents/DataScience/R_work") # write data file
write.xlsx(iris, 'iris.csv')

methods(plot) # check methods

a1 = iris
a2 = cars

save(a1, a2, file = 'a.rdata') # rdata save and load
load('a.rdata')

```

> **1.2 데이터 manipulation**

```R

x1 = matrix(1:15, nrow=5)
x2 = matrix(1:15, nrow=5, byrow = T)

rbind(x1,x2) # bind row data

x3 = c(1,3) # concatenate vector data
for(i in 1:10){
  x3 = c(x3, i)
}

x4 = c(1,2,3)
x5 = c(5,6,7)

cbind(x4, x5)
rbind(x4, x5)

### merge example1
xx <- data.frame(name=c("a", "b", "c", "d"), math=c(1,2,3,4))
yy <- data.frame(name=c("c", "b", "a"), english=c(4,5,6))
merge(xx, yy) # x에는 있는데 y에는 없는거 제외하고 merge.

### merge example2
xx <- data.frame(name1=c("a", "b", "c", "d"), math=c(1,2,3,4))
yy <- data.frame(name2=c("c", "b", "a"), english=c(4,5,6))
merge(xx, yy)
merge(xx, yy, all=T, by.x='name1', by.y='name2')

### subset & set factor
s1 = subset(iris, Species == "setosa")
str(s1)
str(iris)
s1$Species = factor(s1$Species)
str(s1)

### species를 기준으로 iris데이터를 리스트로 쪼갬
s2 = split(iris, iris$Species)
str(s2)

### sort, order
s3 = c(1,5,3,7,9,2)
sort(s3, decreasing = F)
order(s3, decreasing = F) # current index of sorted data

### remove NA data
mean(c(1:5, NA), na.rm = T) # NA data remove

### find location
k = c(2,4,6,7,10)
which(k %% 2 == 0) # return index

```

> **1.3 apply 함수**

- 주로 array나 matrix 데이터 구조를 처리하기에 용이함.
- row나 column 단위의 연산을 할 때.
- lapply, sapply 가 제일 많이 쓰이지만 최신버전의 R 에서는 내장되어있기 때문에 코딩할 일은 별로 없다.
- tapply, mapply 등의 특수한 apply 함수를 유용하게 사용해야 한다.

```R

### apply function
d <- matrix(1:9, ncol=3)
mean(d)
mean(d[1,])
for (i in 1:nrow(d)){
  print(mean(d[i,]))
}

apply(d, 1, sum) # 1 : by row
apply(d, 2, sum) # 2 : by column (attributes = features)

# lapply : list return
# sapply : vector return
# tapply : group processing

tapply(iris$Sepal.Length, iris$Species, sum)

list_data1 <- list(a = 1:5, b = 6:10)
mapply(sum, list_data1$a, list_data1$b)

```

> **1.4 doBy**


```R

### doBy
# install.packages("doBy")
library(doBy)
?summaryBy
summary(iris)
summaryBy(.~Species, iris) # 모든 attribute를 species를 기준으로 요약
summaryBy(Sepal.Length~Species, iris, FUN = median) # Sepallegnth를 species 기준으로 요약, median func로.
# == aggregate(Sepal.Length~Species, iris, FUN = median)

sample(1:20, 200, replace = T, prob = c(1,3,3, rep(1,17))) # 2,3이 많이 뽑힌다.
sampleBy(Sepal.Length~Species, data = iris, frac = 0.1, systematic = T) # 종 별로 10%씩 샘플링

```

-----------------------


#### **3. 집단간 차이검정**

- t 검정

```


```

-----------------------
