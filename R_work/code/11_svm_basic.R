setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

data <- read.csv("svm.csv", header = F)
colnames(data) <- c("X","Y")
data <- data[1:20, ]
str(data)

### plot the data
plot(data, pch=16)

### linear regression
model <- lm(Y~X, data)
plot(model)

### SVM regression
library(e1071)
model1 <- svm(Y~X, data)
model2 <- svm(x=data$X, y=data$Y)
predictedY <- predict(model1)

model1$kernel # kernel index
model1$cost # cost is margin of svm model
model1$coefs # weight : weight는 서포트 벡터 개수만큼 만들어짐
model1$nSV # 서포트 벡터의 개수
model1$fitted # 추정값

# 에러 구하는 함수
rmse <- function(error) {
  sqrt(mean(error^2))
}

rmse(data$Y-model1$fitted)
points(data$X, model1$fitted, col = "red", pch = "+")

model1_1 = svm(Y~X, data = data, kernel = "linear")
points(data$X, model1_1$fitted, col = "blue", pch = "+")

model1_1 = svm(Y~X, data = data, kernel = "sigmoid")
points(data$X, model1_1$fitted, col = "green", pch = "+")

### svm모델 튜닝
# Ten folder cross validation 기법이 내장되어있음.
# -> 데이터를 10개로 나눈 뒤, 1번째 폴더를 제외하고 SVM을 돌리고
# -> 2번째를 제외하고 SVM을 돌리고를 반복~
# -> 최적의 모형을 찾기위한 반복 과정임.
tuneResult <- tune(svm, Y~X, data=data,
                   ranges = list(epsilon = seq(0,1,0.1)),
                   cost = 2^(2:9))
tuneResult$best.model
pred1 = predict(tuneResult$best.model, newdata = data)

plot(data, pch="+")
points(data$X, model1$fitted, pch='*', col="blue")
points(data$X, pred1, pch='*', col="red")

### svm 시계열 분석
# Ex: n-5 ~ n-1 전날의 데이터로부터 n 날의 데이터를 예측
data1 = seq(1, 500, 2)

d1 = array(dim=c((500/6), 6))
for (i in 1:(500/6)){
  d1[i,]=data1[i:(i+5)]
}

X = d1[, 1:5]
Y = d1[, 6]

model3 <- svm(x=X[1:60], y=Y[1:60])
pred2 = predict(model3, newdata = X[61:83, ])
cbind(Y[61:83], pred2)

## 참고 --> 이거 코드 결과가 좀 이상함
# y가 수치형 : as.numeric 이 되면 회귀문제가 되고
# y가 범주형 : as.factor 가 되면 분류문제가 된다.
# R에서는 자동으로 이를 결정한다.
library(mlbench)
data(Vowel)

data11=Vowel
data11$Class = as.numeric(data11$Class)
model_vowel1 = svm(Class~., data11[, -1])
model_vowel2 = svm(Class~., data11[, -1], type='C-classification', kernel='sigmoid')

model_vowel1$fitted
model_vowel2$fitted 
# model_vowel2 --> 데이터가 numeric으로 들어가긴 했지만, 
# sigmoid로 레이블 분류하라고 명시했으므로 회귀가 아닌 분류가 되었음.

t1 = table(data11$Class, model_vowel1$fitted)
t2 = table(data11$Class, model_vowel2$fitted)
sum(diag(t1))/sum(t1)
sum(diag(t2))/sum(t2)
