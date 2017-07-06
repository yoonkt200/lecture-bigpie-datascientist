setwd("/Users/yoon/Documents/DataScience/R_work")

options(digits = 3) # 소수점 이하 표시
set.seed(100)

x1 = rnorm(100, mean=0, sd=3)
hist(x1)
plot(density(x1)) # 확률밀도로 나타낸 것

var(x1)
mean(x1)
median(x1)
quantile(x1, c(0.25, 0.5, 0.75))

### 위치 나타내기
q1 = quantile(1:10, c(1/4, 3/4))
str(q1)
q1

### sampling
# 샘플링된 데이터를 분리하는 방법 1
sample(1:10, 5, replace = T, prob = 1:10) # prob는 가중치
ind1 = sample(nrow(iris), nrow(iris), replace = F)
A1 = iris[ind1,] # ???
A1
n1 = nrow(iris)
train = A1[1:(n1*0.7),]
test = A1[-(1:(n1*0.7)),]

# 샘플링된 데이터를 분리하는 방법 2
ind2 = sample(n1, n1*0.7, replace = F)
train1 = iris[ind2,]
test1 = iris[-ind2,]

# 샘플링된 데이터를 분리하는 방법 3
ind3 = sample(2, n1, replace = T, prob = c(0.7, 0.3))
ind3
table(ind3)
train2 = iris[ind3 == 1,]
test2 = iris[ind3 == 2,]

### 특정데이터 추출과 필터링
#install.packages('sampling')
library(sampling)
x = strata(c("Species"),
         size = c(3, 3, 1),
         method = "srswor", # srswor : replace F // srswr : replace T
         data = iris)

getdata(iris,x)

### repeat option
rep(c(3,7), c(3,2)) # 3은 3번, 7은 2번 반복하는 함수
rep(c(3,7), each=3)
rep(1:15, length.out=15)
rep(1:10, length.out=15)

### row, group manipulation
iris$Species2 = rep(1:2, 75)
strata(c("Species", "Species2"), size=c(5,1,1,1,1,1), method="srswr", data=iris)

library(doBy)
sampleBy(~Species+Species2, # Spcecies 1, 2 를 묶은것을 하나의 그룹으로 보는 것.
         frac = 0.3, 
         data = iris)

d1 = data.frame()
for (i in seq(sample(1:10, 1))){
  d2 = iris[i, ]
  d1 = rbind(d1, d2)
}
d1

### table processing
d <- data.frame(x=c("1","2","2","1"), y=c("A","B","A","B"), num=c(3,5,8,7))
d_bind = rbind(d,d)
table(d_bind$x, d_bind$y)
xtabs(num ~ x+y, data=d)
xt = xtabs(num ~ x+y, data=d_bind)

sum(xt)
margin.table(xt)
margin.table(xt, 1) # row sum
margin.table(xt, 2) # col sum
prop.table(xt, 1)

tot = sum(xt)
p_xt = prop.table(xt)

str(p_xt)
tot*p_xt[[1]][1]

### 독립, 연관성 검정
library(MASS)
data('survey')
View(survey)
xt = xtabs(~Sex+Exer, data = survey)
xt

chi1 = chisq.test(xt) # p-value가 0.06, 즉 0.05 이상이므로 성별과 운동 빈도는 관계가 있는 것 같다.
chi1
str(chi1)
chi1$statistic

# 카이제곱의 샘플 수가 작을 때 피셔테스트를 사용함. 비슷한 방식인데 샘플 수가 적을 때 조금 더 정확함.
fisher.test(xtabs(~W.Hnd+Clap, data = survey))

table(survey$W.Hnd)
chisq.test(table(survey$W.Hnd), p=c(.3, .7)) # 대상 데이터의 비율이 3:7 이다 라는 가설에 대한 검정

### 맥니마 검정 ???

### shapiro test -> 정규성 여부 검정
shapiro.test(rnorm(100))

### ks test -> 분포가 동일한지 여부 검정
ks.test(rnorm(100), rnorm(100, 5, 3))

### qqnorm -> 그래프를 통한 정규성 검정
x <- rnorm(1000, mean = 10, sd=1)
qqnorm(x) # 직선의 형태로 그려질수록 정규성을 띤다고 할 수 있다.
plot(density(x))
