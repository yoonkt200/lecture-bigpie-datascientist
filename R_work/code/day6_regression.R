setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)

### 단순선형회귀
# 데이터를 분석하기에 앞서, 플롯으로 데이터의 경향을 파악하는 것이 중요.
plot(cars)
cor.test(cars$speed, cars$dist) # 귀무가설 : 상관관계가 0이다

model1 = lm(dist ~ speed, cars)
summary(model1)

par(mfrow = c(2, 2))
plot(model1)
# 첫번째 플롯은 잔차 플롯으로, dist의 적합값과 잔차를 그린 플롯이다. 잔차의 등분산성과 독립성을 검정하기 위한 플롯이다.
# 평균을 기준으로 골고루 분산되어 있는 것이 좋은 모양
# 두번째 플롯은 정규 플롯으로, 잔차의 정규성을 검정하기 위한 플롯이다.
# 세번째 플롯은 표준화 잔차 플롯으로, 잔차플롯과 비슷하다.
# 네번째 플롯은 지레-잔차 플롯으로, X값과 Y값의 특이값을 찾아내는데 유용한 플롯이다. 빨간 점선이 outlier의 기준.
plot(model1, which=1:6)
plot(model1, which=1, xlim=c(20,60))

par(mfrow = c(1, 2))
plot(model1, which = c(4, 6))

# 첫번째 플롯은 관찰값별 Cook's Distance(Cook의 거리)를 구한 것으로, 이상치를 판별하는데 사용된다. 
# 두번째 플롯은 Cook의 거리와 지레값을 플롯한 것으로, X공간과 Y공간의 이상치를 동시에 판별하는데 사용된다.

library(car)
durbinWatsonTest(model1$residuals)

predict(model1, newdata = data.frame(speed=c(3,7)))

### 다중선형회귀
n = nrow(iris)
set.seed(200)
ind = sample(1:n, n*0.7, replace = F)
train = iris[ind,]
test = iris[-ind,]

model2 = lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, train)
summary(model2)

par(mfrow = c(2, 2))
plot(model2)
durbinWatsonTest(model2$residuals)

# 다중공선성 : Vif 값 기준은 10
vif(model2) # 10이 넘는 값 두개가 있으므로 다중 공선성 문제 존재.

model3 = lm(Sepal.Length ~ Sepal.Width, train)
summary(model3)
plot(train$Sepal.Length, train$Sepal.Width)

cor(train[, 2:4])
model4 = lm(Sepal.Length ~ Sepal.Width + Petal.Length, train)
summary(model4)

### 변수 선택 기법
library(mlbench)
data("BostonHousing")
m <- lm(medv ~., data = BostonHousing)
summary(m)
m2 <- step(m, direction = "both")
summary(m2)
# AIC가 작아지다가 더 이상 작아지지 않는 모형이 최종적으로 선택되는 모형.

m3 = step(lm(medv~1, BostonHousing), direction = 'forward', scope = "~chas + crim + zn + b + tax + rad + nox + ptratio + dis + rm + lstat")
summary(m3)

## outlier 처리
o1 = outlierTest(m)
o1$rstudent
names(o1$rstudent)
o2 = as.numeric(names(o1$rstudent))

B2 = BostonHousing[-o2,]

## 적용
install.packages("mixlm")
library(mixlm)

pred1 = predict(model2, newdata = test)
pred2 = predict(model4, newdata = test)

# (실제값 - 예측값 = 잔차)^2 -> 잔차제곱 
mse1 = mean((test$Sepal.Length - pred1)^2) # 잔차제곱평균
rmse1 = sqrt(mse1)

mse2 = mean((test$Sepal.Length - pred2)^2)
rmse2 = sqrt(mse2)

c(mse1, mse2, rmse1, rmse2) # 1,2 중에 값이 작은 것이 더 좋은 모델이라고 할 수 있음.


### 더미변수
d1 = lm(Sepal.Length~., train)
summary(d1)

nlevels(train$Species)
levels(train$Species)
d1 = stats::lm(Sepal.Length~., train)
summary(d1)

cbind(test$Species, as.numeric(test$Species))

# 즉, 이런 식이 나오게 된다는것.
Sepal.Length = 1.51742 + (Sepeal.width*0.53750 
                 (beta)   + Petal.length*0.84724 
                          + Petal.width*-0.39791 
                          + Species(setosa)*0.53557 
                          + Speciss(versicolor)*-0.13797)
# Species가 3개짜리 factor이면 그 중 하나를 기준으로 하고, 위 식 처럼 두개의 species 더미 변수가 생성됨.
# Q : 그럼 기준이 되는 factor에 대한 변화량은 어떻게 알 수 있는가?? -> beta에 포함되어 있다.
# if : predict input data가 setosa 라면, setosa는 1, versicolor는 0이 된다. 
# 즉, 최종 결과에 + 0.53557이 되느냐 -0.13797이 되느냐의 차이.
# 기준이 되는 species에 대한 것은 알아서 처리됨.



### 비선형 회귀
x = sample(0:2*pi, 1000, replace=T)
y = sin(x)
e = rnorm(1000, 0, 1)
y_e = y+e
plot(x, y_e)

# 샘플데이터 생성
x1 = seq(0, 2*pi, 0.01)
data = data.frame()
for(i in x1){
  e1 = rnorm(10, 0, sample(1:3, 1, replace = T))
  y1 = sin(i) + e1
  x2 = rep(i, 10) # rep -> repeat의 약자
  data1 = cbind(x2, y1)
  data = rbind(data, data1)
}
plot(data, cex=0.1)

# 선형 라인 그리기
non1 = lm(y1~x2, data)
line(data$x2, non1$fitted.values)
abline(non1, col='red')

### SVM 다중 회귀
install.packages('e1071')
library(e1071)

svm1 = svm(y1~x2, data) 
# 참고 : svm은 svc, scr로 classification / regression 용으로 나뉨. 
# R에서는 y가 연속형이면 svr, y가 factor형이면 svc로 자동 실행함.
pred1 = predict(svm1, newdata = data)
points(data$x2, pred1, col = 'red', pch = "*", cex = 0.3)
points(data$x2, sin(data$x2), col='blue', pch="#", cex=0.4)

non_svm1 = lm(y1~x2, data)
pred2 = predict(non_svm1, newdata = data)
rmse_s = sqrt(mean(data$y1-pred1)^2)
rmse_n = sqrt(mean(data$y1-pred2)^2)
c(rmse_s, rmse_n) # --> svm과 non-svm 수치 비교
# 참고 :  lm은 변수들의 계수, p-value등 각종 지표로 모델을 평가할 수 있지만,
# svm은 rmse로 모델을 평가하는게 거의 유일한 방법. 따라서 그래프를 통해 직관으로 발견하거나 rmse로 평가하는게 일반적임.

svm2 = svm(Species~., train)
pred3 = predict(svm2, newdata = test)
t1 = table(test$Species, pred3)
diag(t1) # table의 대각선 값을 추출하는 함수
sum(diag(t1)) / sum(t1) # 전체 중에 잘 맞힌것만 찾아낸 비율

##### result : 최적의 함수 찾는 것은 rmse, 분류 평가하는 것은 table 활용