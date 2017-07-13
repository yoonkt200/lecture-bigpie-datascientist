# 4일차 


-----------------------


#### **1. 분류 알고리즘**


> **1.1 분류의 기법**

```
- y값은 범주형 데이터(그룹 변수)여야 분류가 가능한 수식이 완성됨.

- 수식은 회귀식일 수도 있고 회귀식이 아닐 수도 있음.
```

> **1.2-1 로지스틱 회귀**

```
- 로지스틱 회귀의 경우는 수식의 y값이 0~1 사이의 확률이 됨. 

- 이때의 확률은 이진 그룹에 속할 확률임.

- 만약 y = b + ax라는 식이 있다고 할 때, 이 식은 y가 0~1로 나오지 않을 수 있음.

- 따라서 f(x)의 결과가 0~1 확률로 나올수 있도록 함수를 구성해주는 것이 로지스틱 함수의 아이디어이다.

- y에 log를 취해서 오른쪽 x값에 대한 balance를 맞춰준 뒤, 양쪽에 e를 취하여 정리하는 것이 수학적 원리.
```

```R
# 데이터셋 나눠서 로지스틱 회귀
set.seed(1000)
ind = sample(1:nrow(data1),
             nrow(data1)*0.7,
             replace = F)
train = data1[ind, ]
test = data1[-ind, ]
m <- glm(Species~., data = train, family = "binomial")
m$fitted.values
train_y = ifelse(m$fitted.values>=0.5, 2, 1)
table(train_y)
table(train$Species, train_y)

pred1 = predict(m, newdata = test, type = 'response')
# response는 0~1사이의 결과값을 구해준다.
pred_label = ifelse(pred1 >= 0.5, 2, 1)
table(test$Species, pred_label)

test$label = pred_label
View(test)
```

> **1.2-2 로지스틱 회귀 수식의 의미**

```
수식 설명
```

> **1.3-1 다항 분류 회귀**

```
- 로지스틱 회귀의 아이디어를 확장시킨 것.

- 로지스틱 회귀는 binary한 것에 대한 확률이었다면, 다항 로지스틱 회귀는 3개 이상의 레이블을 가진 분류문제.

- 각각마다 로지스틱 함수를 통해 이항적인 확률을 구하여 합계를 낸 뒤, 확률의 합이 1이 되게끔 비율을 재조정.

- 즉, a일 확률 0.2, b일 확률 0.5, c일 확률 0.3 이런식으로 합이 1이 되는 확률값으로 표현함.
```

```R
set.seed(1000)
ind = sample(1:nrow(iris),
             nrow(iris)*0.7,
             replace = F)
train = iris[ind, ]
test = iris[-ind, ]
library(nnet)
(m <- multinom(Species~., data=train))
m$fitted.values
m_class <- max.col(m$fitted.values)

table(m_class)
table(train$Species, m_class)

pred3 = predict(m, newdata = test, type = 'class')
# class는 factor 결과값을 구해준다.
table(pred3)
table(test$Species, pred3)
```

> **1.3-2 다항 분류 회귀 수식의 의미**

```
수식 설명
```

-----------------------


#### **2. 의사결정 트리**


> **1.1 개념**

```
의사결정 트리는 분류 문제이기도 하고, 예측 문제이기도 한데, 주로 사용되는 분야는 지도 분류 학습이다.

어찌되었든 의사결정 트리의 메인 아이디어는 데이터를 스무고개처럼 분석하여 최종적 판단에 이르는 패턴을 찾아내는 것이다.

다음의 그림은 의사결정트리를 나타내는 대표적인 예시인 타이타닉호 생존 결정 트리이다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/3.png)

```
결정트리에서 중요한 내용으로 다음과 같은 크게 3가지가 있다.

1. 노드 분기 방법
2. 모델 학습 과정
3. 가지치기
```

> **1.2 노드 분기 방법**

> **1.3 모델 학습 과정**

```
결정 트리에서의 학습은, 학습에 사용되는 자료 집합을 적절하게 분기시키는 것이다. 노드를 분기함에 있어서
'순환 분할'이라 불리는 재귀적 분기(recursive partitioning) 과정과 가지치기 두 가지로 진행된다. 
분할로 인해 더 이상 나은 결과가 나오지 않을 때까지 반복된다.


```

> **1.4 가지치기**


-----------------------


#### **3. 랜덤 포레스트**

