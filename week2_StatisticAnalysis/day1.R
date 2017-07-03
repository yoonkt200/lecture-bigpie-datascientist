setwd("C:/Users/ajou/Desktop/DataScience/R_work")

################################################ 대략적인 문법
summary(iris)

x = table(iris$Species)
x3 = 1:10
x4 = c(1,5,3,9)
x4[2]

row_3 = matrix(1:15, nrow=3)
col_3 = matrix(1:15, ncol=3)

mat_byrow = matrix(1:15, ncol=3, byrow=T)
mat_bycol = matrix(1:15, ncol=3, byrow=F)

a = mat_byrow[-c(2,4),3 ] # 2,4 번째 row를 제외하고, 3번째 열의 값을 선택.

str(iris)
################################################



################################################ 통계분석 기초
x1 = c(1,2,3,4,5,4,3,6,7,1000)

# 이상치를 제거하지 않은 평균 계산법
sum(x1)/length(x1)
mean(x1)

# 위의 방식은 부적절하므로, 중앙값 이용.
median(x1)

# --> 둘 중에 적당한 방식을 찾아서 사용해야 함.

sample(1:45, 6, replace = T) # 복원추출 샘플링

#### 샘플링 예제
### iris data에서 70%를 트레이닝 셋으로 비복원 랜덤 샘플링, 나머지를 테스트셋으로.
ind = sample(1:nrow(iris), nrow(iris)*0.7, replace = F)
A1 = iris[ind, ]
View(A1)

train = iris[ind, ]
test = iris[-ind, ]

#### summary 의미 정리
summary(iris)

# 1st ~ : 첫번째 4분위수.
# median : 두번째 4분위수. 정중앙.
# 3st : 세번째 4분위수.
# mean : 산술평균

#### 그래프를 이용해 데이터의 대략적인 패턴을 관찰해야 함.
hist(iris$Petal.Length)
boxplot(iris[, 1:4])

View(iris)
scaled_data = scale(iris[, 1:4]) # 5는 label 이므로 안함.
View(scaled_data)

# 자료의 카테고리 숫자 확인
nlevels(iris$Species)

# 자료의 카테고리 확인
levels(iris$Species)

library(MASS)
data("survey")
View(survey)

# table -> 관계요약
table(survey$Sex, survey$W.Hnd)
t1 = table(survey$Sex, survey$Smoke)

# prop.table -> 관계요약을 비율로 표현.
prop.table(t1) # 전체 합이 1이 되도록
prop.table(t1, 1) # 행의 합이 1이 되도록
prop.table(t1, 2) # 열의 합이 1이 되도록

barplot(t1)
