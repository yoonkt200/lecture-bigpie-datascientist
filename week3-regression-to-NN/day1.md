# 1일차 


-----------------------


#### **1. 선형 회귀**


> **1.1 단순 선형 회귀**

```
- 회귀분석은 독립변수와 종속변수간의 관계를 모델링하는 기법을 말한다.

- 그 중에서 선형회귀는 변수간의 관계가 선형적 형태로 나타나는 경우이다.

- 회귀를 통해 나타난 직선에서부터 멀어진, 측정치의 Y값의 차이를 오차라고 한다.

- 선형회귀는 Y = a1X1 + a2X2 + ... + b 의 수식으로 나타낼 수 있다. (단순 선형 회귀는 변수가 1개)

- 표본이 등분산일 경우 측정치, 오차가 직선 근처에 모여있어 예측이 상대적으로 좋지만, 이분산일 경우 측정치가 물결을 치게 되므로 선형적 예측이 좋지 않다.

- 그래서 선형 회귀에서는 등분산을 가정한다.

- 독립 변수간에는 독립을 가정한다 -> 다중 공선성 고려 X

- 회귀계수를 추정하는 방법으로는, 대표적을 최소 제곱법을 사용한다.

- 최소 제곱법이란 오차의 제곱 합이 최소인 지점을 구하는 방법이다.
```

> **1.2 다중 선형 회귀**

```R
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
```


> **1.3 회귀 진단 : 회귀 모형에 관한 진단**

![](https://raw.github.com/yoonkt200/lecture-bigpie-datascientist/master/week3-regression-to-NN/week3-images/1.png)

```
# 첫번째 플롯은 잔차 플롯으로, dist의 적합값과 잔차를 그린 플롯이다. 잔차의 등분산성과 독립성을 검정하기 위한 플롯이다.
# 평균을 기준으로 골고루 분산되어 있는 것이 좋은 모양
# 두번째 플롯은 정규 플롯으로, 잔차의 정규성을 검정하기 위한 플롯이다.
# 세번째 플롯은 표준화 잔차 플롯으로, 잔차플롯과 비슷하다.
# 네번째 플롯은 지레-잔차 플롯으로, X값과 Y값의 특이값을 찾아내는데 유용한 플롯이다. 빨간 점선이 outlier의 기준.
```

- 오차항의 등분산성 검정

```
- 잔차 그래프를 통해 등분산성을 검정한다.

- 잔차 그래프의 세로축은 표준화된 잔차의 값이고, 가로축은 종속변수에 대한 수치이다.

- 잔차 그래프에서 패턴 없이 수평축 0을 기준으로 대칭적으로 무작위로 흩어져 있을 경우, 등분산성을 갖는다고 판단할 수 있다.
```

- 오차항의 정규성 검정

```
- 오차항의 정규성은 잔차의 Normal Probability Plot (Q-Q plot)으로 검토할 수 있다.

- 그래프의 가로축은 잔차의 정규 분포 하에서의 기대값, 세로축은 실제 잔차의 관측값이다.
```

- 오차항의 독립성 검정(Durbin-Watson)

```
- 관찰값들 사이에 상관관계를 파악하면서, 오차항의 독립성을 검증해야 한다.

- 오차항들이 서로 독립이라면, 무작위로 흩어져 있고, 아니라면 패턴을 가지고 흩어져 있을것이다.

- 이러한 것을 평가하는 측도로 Durbin-Watson 통계량이 있다.

- 통계량이 2에 가까우면 상관관계가 없는 독립, 0에 가까우면 양의 상관관계, 4에 가까우면 음의 상관관계를 띤다는 것이다.

- 다음은 독립변수 개수에 따른 더빈 왓은 통계량의 일반적인 하한과 상한의 기준이다.

- 1개 1.65, 1.69

- 2개 1.63, 1.72

- 3개 1.61, 1.74

- 4개 1.59, 1.76

```

> **1.4 변수 선택**

- 단계적 변수 선택

```
- 전진 선택법

- 변수 소거법

- 단계적 방법
```

- AIC(Akaike’s An Information Criterion) : 

```
AIC는 모형을 비교하는 방법 중 하나이다.

이 계수는 모형의 통계적 적합성에 필요한 인수의 숫자를 설명해 준다. 

AIC 값이 적은 모형, 즉 적은 인수를 가지고 적절한 적합성을 보이는 모형이 선호된다

R의 step 함수를 통해 확인할 수 있는데, 

AIC가 작아지다가 더 이상 작아지지 않는 모형이 최종적으로 선택되는 모형이다.
```

- MSE, RMSE 비교 방법

```R
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
```

- 다중공선성 검증

```R
# 다중공선성 : Vif 값 기준은 10
vif(model2) # 10이 넘는 값 두개가 있으므로 다중 공선성 문제 존재.

# Sepal.Width Petal.Length  Petal.Width 
#     1.26576     14.18554     13.44126 
#
# Petal.Length, Petal.Width은 다중 공선성에 문제가 있음.
```

> **1.5 더미 변수**

- 회귀분석에서는 연속형 변수를 추론하게 되지만, 범주형 변수(factor)가 포함되는 경우가 많다.

- 이 경우, 해당 변수를 더미형 변수로 변환하여 연속형 변수처럼 만들어야 회귀분석이 가능하다.

```
해당 변수의 범주의 개수가 n개라면 n-1개의 더미변수를 만든다.

n-1이 되는 이유는, 하나의 더미변수는 기준이 되는 값이라고 보면 된다. 일반적으로 빈도수가 가장 높은 것을 기준으로 한다.
```

```R
d1 = lm(Sepal.Length~., train)
summary(d1)

# -> summary 결과
#                    Estimate Std. Error t value Pr(>|t|)    
#(Intercept)          1.51742    0.33942   4.471 2.08e-05 ***
#Sepal.Width          0.53750    0.10749   5.001 2.48e-06 ***
#Petal.Length         0.84724    0.08510   9.956  < 2e-16 ***
#Petal.Width         -0.39791    0.20264  -1.964   0.0524 .  
#Species(setosa)      0.53557    0.25435   2.106   0.0378 *  
#Species(versicolor) -0.13797    0.07614  -1.812   0.0730 . 

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
```

-----------------------


#### **2. 비선형 회귀**

> **2.1 SVM를 이용한 비선형 회귀**

- SVM : 고차원의 입력에 대해, 변환함수를 통해 가중치를 찾게 됨

```
이론을 통해 배우는 회귀분석은 대부분 선형적인 모형을 가정하고 있다.

하지만 실제의 데이터는 대부분 선형성을 만족하지 못한다. 

따라서 실제적으로 데이터 분석에서 처리해야 하는 데이터는 비선형적인 모델이라고 할 수 있다.

선형 모형은 독립변수에 따라 종속변수가 일정한 변화, 즉 선형성을 보이지만

비선형 모형은 일정한 변화를 보이지 않는다. 수학적인 의미로는, df가 계속 변한다고 할 수 있다.

사인함수나 지수함수처럼 선형적인 모양을 하지 않는 독립변수를 포함하는 모형을 일반적으로 비선형 모형이라 한다.
```

- R에서의 SVM 회귀 분석 코드

```R
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
```