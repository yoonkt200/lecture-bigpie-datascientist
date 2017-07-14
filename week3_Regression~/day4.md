# 4일차 


-----------------------


#### **1. 분류 알고리즘**


> **1.1 회귀분석에서의 분류의 기법**

```
- y값은 범주형 데이터(그룹 변수)여야 분류가 가능한 수식이 완성됨.

- 수식은 회귀식일 수도 있고 회귀식이 아닐 수도 있음.
```

> **1.2-1 로지스틱 회귀**

```
로지스틱 회귀는 독립변수의 선형 결합을 이용하여 사건의 발생 가능성을 예측하는 통계적 기법이다.
따라서 로지스틱 회귀의 y값은 0~1 사이의 확률이 되는데, 이때의 확률은 이진 그룹에 속할 확률이다. 
또한 로지스틱 회귀는 선형 회귀 분석과 다르게, 종속변수가 범주형 데이터이다.

- 만약 일반적인 수식 y = b + ax라는 식이 있다고 할 때, 이 식은 y가 0~1로 나오지 않을 수 있음.

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

> **1.2-2 로지스틱 회귀 추가설명**

```
로지스틱 회귀는 일반적인 선형 모델의 특수한 모델로 볼 수 있다. 하지만 로지스틱 회귀 모델은 종속변수와 독립변수
사이의 관계에 있어서 선형 모델과 차이점이 있다. 

첫 번째로, 종속변수 y의 결과가 [0,1]로 제한된다는 점.
두 번째로, 종속변수가 binary하기 때문에, 정규분포 대신 이항분포를 따른다는 점이다.

이러한 차이점은 다음과 같은 수식으로 제안되어진 것이다. 
이러한 로지스틱 모형을 사용하게 되면, 위의 두 가지 사항을 만족시키게 된다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/logistic.png)

```
logistic function은 odds ratio를 logit 변환한 수식이라고 할 수 있다.

odds ratio는 성공확률이 실패 확률에 비해 몇 배 더 높은지를 나타내는 수식이며,
logit 변환은 오즈에 로그를 취한 함수로써, 어떠한 입력에도 출력값의 범위가 [0,1]에 속하게 하는 수식이다.
이러한 수식과 아이디어를 실행하여 예측 및 분류 문제에 적용하는 것이 로지스틱 회귀 기법이다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/odds.png)

![](https://raw.github.com/yoonkt200/DataScience/master/week3_Regression~/week3_images/logit.png)

```
로지스틱 회귀에서 모델 피팅은 결과 모델이 개선될 때 까지(주로 오차항을 이용한다) 계수를 반복적으로 수정해나가는 반복처리를 수행한다.
이때, 아무리 반복해도 모델이 적합하게 수렴하지 않는 경우는 여러가지 이유가 있지만, 가장 대표적인 원인으로

다중 공선성, 희소성, 완분성 등이 있다. 이에 대해서는 나중에 자세히 공부할 예정이다.
반복처리를 수행하는 대표적인 알고리즘으로 Gradient Descent가 있다. 
이 알고리즘은 오차항을 함수로 표현한 뒤, 오차항이 최소가 되어가는 지점을 미분을 통해 점진적으로 찾아내는 방법이다.
```

> **1.3 다항 분류 회귀**

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
변수와 지점을 선택하여 분기를 하게된다. 이 과정을 하위노드도 재귀적으로 반복한다고 하여 재귀적 분기라고 불리는 것이다.
```

> **1.4 가지치기**

```
결정 트리에서 depth가 불필요하게 크거나(일반적인 depth는 3~4개가 적당), leaf node가 많아지는 경우 데이터가 트리에 과적합
되었을 가능성이 매우 높다. 이는 새로운 자료에 적용할 때 예측오차가 매우 클 가능성이 있다는 것을 의미한다.

따라서 가지치기(pruning)을 통해 모든 terminal node의 불순도가 0인 풀 트리(full tree) 상태를 방지해야 한다.

결정 트리에서의 분기 수가 증가하면, 모델 학습 과정에서는 오분류율이 감소할 수 있으나, 일정 수준 이상을 넘어서거나 검증
데이터를 넣기 시작하면 오분류율이 증가하게 된다. 이는 새로운 데이터에 대한 예측 성능인 일반화 능력이 떨어지는 것을 
의미한다. 그래서 가지치기를 하기에 적당한 지점은, 분기 수가 증가하는 지점이면서 동시에 input 검증 데이터의 오분류율이 
증가하는 시점이다. 

가지치기를 하기에 적당한 지점을 찾는 것 역시 Greedy한 알고리즘을 사용한다. 잘라낼 가지들, 즉 subtree를 선택해 나가면서
이때의 adjusted error rate(aer)를 측정한다. 어떤 subtree를 잘라냈을 때, 전체 트리의 aer보다 작거나 같으면, 가지치기가 
가능한 후보가 되는 것이다.
```

```R
### data
data("Vowel")
set.seed(100)
ind2 = sample(1:nrow(Vowel),
              nrow(Vowel)*0.7,
              replace = F)
train = Vowel[ind2, -1]
test = Vowel[-ind2, -1]

### pruning
install.packages("tree")
library(tree)
library(MASS)

ir.tr = tree(Class~., train) # 가지치기 전
plot(ir.tr)
text(ir.tr, all = T)

plot(prune.misclass(ir.tr)) 
# 트리의 depth가 적당하면서 misclass가 낮은 지점은 10~15 사이.

ir.tr1 = prune.misclass(ir.tr, best=14) # 가지치기 후
plot(ir.tr1)
text(ir.tr1, all = T)
```

-----------------------


#### **3. 랜덤 포레스트**


> **3.1 개념**

```
랜덤포레스트는 의사결정트리를 앙상블 기법으로 학습시킨 모델이다.


```

부스팅, 배깅도 정리