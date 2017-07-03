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

