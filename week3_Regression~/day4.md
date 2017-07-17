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
랜덤포레스트는 의사결정트리를 앙상블 기법으로 학습시킨 모델로, 오버피팅을 방지하기 위해 고안된 방법이다.
랜덤포레스트 역시 분류와 회귀분석 모두에 사용될 수 있다.
앙상블 학습 기법이란 쉽게 말해, 하나의 예측에 여러가지 알고리즘을 투표를 거쳐 사용하는 것이다.
즉, 랜덤포레스트에서 사용하는 앙상블은 여러 개의 서로 다른 의사결정트리를 만들고, 투표를 통해 결과를 얻어내는 것이다.

하지만 의사결정트리 개념에서 정리한 것 처럼 의사결정 트리를 생성하게 된다면, 
트리들이 모두 똑같거나 비슷한 트리로 생성될 것이다. 배심원 10명을 앉혀놨는데 모두 쌍둥이인 꼴이다(..)

이때 배심원의 출신을 랜덤하게 선정하는 방법이 바로 배깅(bagging == bootstrap aggregating)이다.
배깅은 동일한 전체 데이터를 이용하여 개별 트리들을 학습하는 것이 아니라, 
전체 데이터에서 훈련용 데이터를 샘플링하여 개별 트리를 구성하는 것이다.

이 과정에서는 부트스트랩이라 불리는 것을 통해 샘플링을 하게 되는데,
이때 모집단에서 표본집단 추출하듯이 추출하는 것이 아니라 원 데이터와 같은 크기의 데이터를 추출하기 위해 노력한다.
이때 샘플링의 크기를 조절해서 모델을 튜닝할 수 있는데, 원 데이터와 비슷한 크기라고 항상 좋은 것은 아닌것 같다.
(통상적으로는 80% 정도라고 한다.)
랜덤 포레스트에서 분류기 훈련용 데이터의 샘플링 문제는 쉬운 문제가 아니므로 이정도(부트스트랩 과정)에서 정리하겠다.

배깅 외에도 랜덤 포레스트에 중요한 요소가 있는데, 바로 임의 노드 최적화이다.
각 트리의 노드들은 분할 함수(split function)을 토대로, 데이터가 오른쪽으로 향할 지 왼쪽으로 향할 지를 결정한다.
Neural Net의 activate function과 비슷한 개념이라고 생각할 수 있는데,
(이런 걸 보면 데이터 분석 알고리즘은 대개 비스무레하다) 
이러한 분할 함수는 수식화된 매개변수를 가진다. 매개변수를 X라고 정의한다면, 
X는 feature에 대한 정보(특징 Bagging이라고도 불린다), 임의성, 함수의 기하학적 특성 등을 포함하게 된다.
이때 임의성에 대한 파라미터를 최적화시켜서 최종적으로 파라미터 X를 최적화 시키는 것이 임의 노드 최적화이다.
최적화 방법 역시 고도화된 알고리즘의 영역이므로, 일단은 이 정도의 깊이를 아는것이 중요하다 할 수 있겠다.

추가적으로, 랜덤포레스트에는 부스팅 방법이 적용되기도 하는데, 
부스팅 방법이란 회귀분석의 Lasso와 비슷한 역할을 하는 오분류 벌점 부과 방법이다.
벌점 부과 방법은 회귀나 분류 문제에 있어서 오류를 줄이는 하나의 방법론으로, 
잘못 회귀되거나 분류된 데이터에 높은 가중치를 부과하여 정확도를 향상시키기 위한 방법이다.
회귀 분석에서는 Gradient Descent에서 미분값의 절대값이 매우 큰 것과 비슷한 상황이라고 생각하면 편리하다.

어찌되었든, 랜덤포레스트에서도 부스팅 방법은 모델링을 통한 예측 변수에 대해 오분류된 객체에 높은 가중치를 부여하는 것.
의사결정트리 학습방법 중, 가지치기의 개념과 비슷(역시 데이터 마이닝 알고리즘은 거기서 거기로 돌고 돈다)하다.
한 가지 활용 예시로, R에서 이 개념을 사용한다.
R에서는 변수 중요도 평가라는 파라미터로 활용할 수 있는데, 높은 가중치를 부여하는 대상이 반대일 뿐, 개념은 동일하다.
randomForest라는 함수에서 importance=T 라는 파라미터를 설정하여 불순도 개선에 기여하는 변수를 선택한다.

랜덤포레스트를 정리하자면, Bagging 계열의 알고리즘으로써, 그 기반을 의사결정트리에 둔 알고리즘이라고 할 수 있겠다.
성능 향상을 위해 배깅의 방식 뿐 아니라, 임의 노드 최적화와 부스팅을 추가적으로 수행하기도 한다.
랜덤포레스트는 상당히 성능이 좋은 알고리즘에 속하지만 의사결정트리와 달리, 분석과정이 철저히 black box 형태이다.
물론 프로그래머가 사용하기에는 매우 쉬운데, 조절해줄 파라미터로 
tree depth(or count), data feature, sampling % 정도가 있겠다.

```

> **3.2 적용**

```R
library(randomForest)

### mnist dataset에서 테스트
url = "https://github.com/ozt-ca/tjo.hatenablog.samples/raw/master/r_samples/public_lib/jp/mnist_reproduced"
# prac_test = read.csv(paste(url, "prac_test.csv", sep = "/"))
# prac_train = read.csv(paste(url, "prac_train.csv", sep = "/"))
short_prac_train = read.csv(paste(url, "short_prac_train.csv", sep = "/"))
short_prac_test = read.csv(paste(url, "short_prac_test.csv", sep = "/"))
str(short_prac_train)

# mnist randomforest 학습
train1 = short_prac_train
test1 = short_prac_test
train1$label = factor(short_prac_train$label)
test1$label = factor(short_prac_test$label)

r2 = randomForest(label~., train1)
pred2 = predict(r2, newdata = test1)
t2 = table(test1$label, pred2)
diag(t2)
sum(diag(t2)) / sum(t2)

# 픽셀을 0과 1로만 나누어서 학습
train2 = train1
train2[, -1] = round(train2[, -1]/255)
test2 = test1
test2[, -1] = round(test2[, -1]/255)

start1=Sys.time()
r3 = randomForest(label~., train2)
interval = Sys.time()-start1
pred3 = predict(r3, newdata = test2)
t3 = table(test1$label, pred3)
diag(t3)
sum(diag(t3)) / sum(t3)

# dna 데이터 연습
data("DNA")
View(DNA)
summary(DNA)

ind = sample(1:nrow(DNA)*0.7, nrow(DNA)*0.7, replace = F)
train_dna = DNA[ind,]
test_dna = DNA[-ind,]

start2=Sys.time()
r4 = randomForest(Class~., train_dna)
interval = Sys.time() - start2
pred4 = predict(r4, newdata = test_dna)
t4 = table(test_dna$Class, pred4)
diag(t4)
sum(diag(t4)) / sum(t4)
```