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
의사결정 트리는 분류 문제이기도 하고, 예측 문제이기도 한데, 주로 사용되는 분야는 지도 분류 학습이다. 분기의 기준이
범주형이냐, 연속형이냐에 따라 결과가 분류나 회귀 모두가 가능하다. terminal node의 값이 범주형이라면 분류, 연속형이라면
예측이라는 것이다.

어찌되었든 의사결정 트리의 메인 아이디어는 데이터를 스무고개처럼 분석하여 최종적 판단에 이르는 패턴을 찾아내는 것이다.

다음의 그림은 의사결정트리를 나타내는 대표적인 예시인 타이타닉호 생존 결정 트리이다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/3.png)

```
결정트리에서 중요한 내용으로는 다음과 같은 크게 3가지가 있다.

1. 노드 분기 방법
2. 모델 학습 과정
3. 가지치기
```

> **1.2 노드 분기 방법**

```
의사결정트리는 한 분기때마다 변수 영역을 두개로 구분하게 된다. 컴퓨터 자료구조에서의 binary 트리와 유사한 형태이다.
각 depth에서 의사를 결정하는 기준은, 데이터 마이닝이나 통계 영역에서는 순도(homogeneity), 불순도(impurity), 등으로 
평가하게 된다.

만약 분기 후에 불순도와 불확실성이 감소한다면, 정보획득이 일어난 것이며, 즉 올바른 분기라고 할 수 있는 것이다.

불순도에 대해 쉽게 설명하자면 만약 100개의 데이터 중에 남녀의 비율이 5:5 라면 굉장히 불순한(?) 데이터인 것이고,
분기의 기준이 성별일 때 분기 후에 각 node에서의 불순도는 0이 될 것이다. 그렇다면 이 분기는 올바르게 진행된 것이다.

의사결정트리에서는 불순도나 불확실성이 최대로 감소하도록 학습을 진행하게 되는데, 이 과정은 뒤에 설명할 재귀적 분기
(recursive partitioning)로 진행된다.

불순도를 계산하는 지표는 대표적으로 엔트로피(entropy), 지니 지수(gini index), 오분류 오차(misclassfication error)이다.

지니 불순도는 어떤 집합에서 한 항목을 뽑아 무작위로 라벨을 추정할 때 틀릴 확률을 말한다. 집합에 있는 항목이 모두 같다면
지니 불순도는 최솟값(0)을 갖게 되며 이 집합은 완전히 순수하다고 할 수 있다.
엔트로피 역시 비슷한 논리의 결과로 나온 수치로, 라벨 추정과 관련된 확률이다.
```

- 엔트로피 공식

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/ent.JPG)

- 지니 지수 공식

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/gini.JPG)

> **1.3 모델 학습 과정**

```
결정 트리에서의 학습은, 학습에 사용되는 자료 집합을 적절하게 분기시키는 것이다. 노드를 분기함에 있어서 '순환 분할'이라 
불리는 재귀적 분기(recursive partitioning) 과정이 진행된다. 분할로 인해 더 이상 나은 결과가 나오지 않을 때까지 반복된다.
이 과정은 Greedy한 알고리즘이라고 할 수 있다.

재귀적 분기 과정은 우선 데이터를 한 변수를 기준으로 정렬한 후, 가능한 모든 분기점에 대해 정보획득을 조사한다. 
예를 들어 데이터의 개수가 500개라면, 1:499, 2:498, 3:497 ... 등으로 분기점을 선택한 후 각각의 정보획득을 계산.
그 다음, 다른 변수를 기준으로 정렬한 뒤 위 과정을 반복하고, 최종적으로 나온 모든 경우의 수 가운데서 가장 정보획득이 큰
변수와 지점을 선택하여 분기를 하게된다. 이 과정을 재귀적으로 반복한다고 하여 재귀적 분기라고 불리는 것이다.
```

> **1.4 가지치기**

```

```

-----------------------


#### **3. 랜덤 포레스트**

