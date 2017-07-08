# 4일차 


#### **1. 독립, 연관성 검정**

> **1.1 카이제곱 검정**

```

- 관찰된 빈도가 기대되는 빈도와 다른지의 여부를 검증하는 방법.

- z, t검정은 평균값에 대한 가설 검정에 사용되는 반면, 카이제곱은 확률에 대한 가설 검정이다.

- 카이제곱은 표본이 적거나, 오버피팅 되어있다면 검정결과가 매우 부정확할 수 있다.

- 이 경우 주로 fisher test를 사용함.

```

-----------------------


# 5일차 


#### **1. 분산분석**

> **1.1 집단 차이 검증**

```
집단간의 평균 차이를 검증하는 방법으로 t-검정이 있다. t-검정은 주로 두 집단을 비교할 때 사용한다. 

물론 여러 집단간의 차이 검정에도 t-test가 쓰일 수는 있지만, 1종 오류가 커진다는 문제가 발생한다. 

세 집단 이상 평균 비교에 대한 오류의 증가 관계는 다소 어려운 내용이므로, 데이터 분석만을 위해서는 알 필요는 없다.

어찌되었든 이러한 여러 집단간의 차이검증을 t-test로 하는 것에 의한 문제점을 해결하기 위해 해야되는 것이 분산분석이다. 

분산분석은 회귀분석의 한 형태라고 할 수 있는데, 집단 간 분산을 비교과정에 이용하는 것이 핵심 아이디어이다. 

집단 간 분산이란, 각 케이스의 관찰값과 전체 평균 간 차이인 편차를 제곱하여 합산한 뒤, 각 케이스의 자유도로 나누게 되면(표본크기)분산의 비를 알 수 있다는 것이다. 

이러한 분산의 비를 이용해서 집단간의 차이가 있는지 아닌지를 판단하는 게 분산분석의 핵심이다.

간단히 말해서, 각 집단의 평균치가 전체 평균으로부터 얼마나 이탈해있는지를 집단 간 분산을 통해 나타내는 것이다.
```

```R
library(MASS)
data("survey")
View(survey)

model1 = aov(Pulse ~ Exer, data=survey)
summary(model1)

model2 = aov(Sepal.Length ~ Species, data=iris)
summary(model2)

model3 = aov(Pulse ~ Exer+Smoke, data=survey)
summary(model3)
# F-value : Mean Sq / Residuals --> 집단간 평균에 잔차를 나눈 것. 
# 즉, 잔차가 클 수록 F가 낮아지는 것이므로 F는 큰게 좋은것.(?)

model3 = aov(Pulse ~ Exer*Smoke, data=survey) 
# ==> model3 = aov(Pulse ~ Exer+Smoke+Exer:Smoke, data=survey) 
# aov(A ~ B, ...) 에서 B에 따라서 A가 얼마나 의미있게 비슷한지에 관한 것.
# : 은 두 변수의 join을 의미, * 은 변수의 부분집합까지 다 보고 싶을 때
summary(model3)

t1 = TukeyHSD(model1, "Exer")
t1 # some-freq 의 경우 집단간의 심박수 차이가 있는 것.

#### 실제 데이터 적용
library(reshape2)
g5 = melt(g4, id=1:17)

model4 = aov(value~variable, data=g5)
summary(model4)

g6 = melt(g4[1:17], id=1)
model5 = aov(value~variable, data=g6)
summary(model5)
t14= TukeyHSD(model5, "variable")

t3 = as.matrix(t14$variable)
```