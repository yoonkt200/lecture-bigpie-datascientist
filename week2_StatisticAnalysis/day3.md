# 3일차 


-----------------------


#### **1. 데이터 조작**


> **1.1 데이터 생성 및 저장**

```R

# write data file
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


#### **2. 집단간 차이검정**

> **2.1 데이터 분석에서 사용하게 되는 가설, 통계량에 대한 기본 용어와 이론**

- 가설검정의 의미 

```
- 통계적 가설 : 표본의 특성을 나타내는 모수에 대한 주장.

- 귀무가설 : 모수에 대한 주장으로, 맞다라는 사실을 입증해야 하는 가설. H0라고 표현함.

- 대립가설 : 귀무가설을 부정하는 가설.
```

- 검정 통계량

```
귀무가설의 진위여부를 판정하기 위해 표본으로부터 얻은 통계량을 검정 통계량이라 한다.

검정 결과 H0이 참인 결과를 얻으면 귀무가설을 채택한다고 하고, 반대라면 기각한다고 한다.

- 채택역 : 귀무가설을 채택하는 검정통계량의 영역

- 기각역 : 기각하는 검정 통계량의 영역

- 유의수준 : 1종 오류를 범할 확률 -> 무엇인가가 잘못 주장될 확률.
```

- 일반적인 검정 순서는 다음과 같다. (예: p값에 의한 검정 순서)

```
1. 대립가설을 설정.

2. 유의수준을 설정.

3. 적당한 검정 통계량을 선정.

4. 유의수준에 대한 기각역을 정함.

5. 표본으로부터 검정 통계량을 관찰함.

6. 관찰값이 기각역에 있는지를 판단하여 기각과 채택을 결정함.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week2_StatisticAnalysis/week2_images/5.png)

> **2.2 R에서 실제 가설 검정**

```

# 평균 180, 표준편차 10인 100개의 표본추출
data1 = rnorm(100, mean=180, sd=10)

t.test(x=data1, mu=180)
t.test(x=data1, mu=200)
# t test 는 두 집단의 평균이 같은지를 검정하는 것.

data2 = rnorm(100, mean=160, sd=5)

var.test(x=data1, y=data2)
t.test(x=data1, y=data2, var.equal = F)

```

-----------------------
