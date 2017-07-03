# 1일차 


-----------------------


#### **1. 개발환경 구축**


> **1.1 기본 설치** : Java 최신버전과 R, Rstudio 설치.

> cmd, terminal 에서 javac 명령어로 자바 설치 및 path 확인.\

> **1.2 javac 명령어가 안될때 / 설정법 (윈도우 7 기준)**

![](https://raw.github.com/yoonkt200/DataScience/master/week2_StatisticAnalysis/week2_images/1.JPG)

![](https://raw.github.com/yoonkt200/DataScience/master/week2_StatisticAnalysis/week2_images/2.JPG)

```
JAVA_HOME 이라는 변수를 추가하고, JAVA_HOME에는 java sdk 설치 경로를 입력한다.

시스템 변수 path에 JAVA_HOME을 추가하고, bin을 하위 디렉토리로 가리킨다.

(;%JAVA_HOME%\bin)
```

![](https://raw.github.com/yoonkt200/DataScience/master/week2_StatisticAnalysis/week2_images/3.JPG)

##### 다음처럼 되었으면 성공.

> **1.3 환경설정**

- General : Default working directory 세팅.

- Code : Saving 탭에서 Default text encoding UTF-8로.

- Appearance : 알아서 보기 좋게 설정하기.



-----------------------


#### **2. 통계분석 기본개념**

> 통계에서 추정이란 표본으로부터 모집단의 성질을 추정해내는 것. 확률 개념이 중요.

> 통계란 또한 수 많은 데이터에서 대표치(평균 등)을 뽑아내는 것.

> 대표치를 뽑아 낼 때, 이상치등의 여부를 확인하고 처리해야 함.

> 분산이란 흩어진 정도를 나타냄.

> 참고 : 가중평균

![](https://raw.github.com/yoonkt200/DataScience/master/week2_StatisticAnalysis/week2_images/4.JPG)

> 전수조사는 리소스 낭비가 심하므로, 샘플링을 해야함. (빅데이터 조차도 모집단이 아님.)



-----------------------




#### **3. 통계이론**

- 모집단 : 통계적 분석을 위한 관심의 대상이 되는 모든 사람, 응답 결과, 실험 결과, 측정값들 전체의 집합

- 통계조사 방법 : 전수조사, 표본조사, 임의추출

```R
#### 복원추출 샘플링
sample(1:45, 6, replace = T) 
# [1] 21 24  9 37 43 32

#### 샘플링 예제
### iris data에서 70%를 트레이닝 셋으로 비복원 랜덤 샘플링, 나머지를 테스트셋으로.
ind = sample(1:nrow(iris), nrow(iris)*0.7, replace = F)
A1 = iris[ind, ]
View(A1)

train = iris[ind, ]
test = iris[-ind, ]

#### 그래프를 이용해 데이터의 대략적인 패턴을 관찰해야 함.
hist(iris$Petal.Length)
```

> feature들의 단위가 정규화되거나 동일한 단위가 아니라면, 계수와 관계없이 영향력이 제멋대로가 된다.

> 따라서 단위마다 정규화, 표준화를 시켜줘야 함. R 에서는 각 변수마다 scale 함수로 시행.

```R
View(iris)
scaled_data = scale(iris[, 1:4]) # 5는 label 이므로 안함.
View(scaled_data)
```

- 자료의 종류

```
양적 자료 (Quantitative data : 숫자로 표현되며 숫자가 의미를 가짐.)

질적 자료 or 범주형 자료 (Qualitative(categorical) data : 숫자에 의하여 표현되지 않고, 여러 개의 범주로 구분되는 자료)

명목 자료 (nominal data) : 각 범주를 숫자로 대치한 자료

> A형 1, B형 2...

순서 자료 (ordinal data) : 순서의 개념을 갖는 질적 자료

> 초등학교 1, 중학교 2, 고등학교 3...

집단화 자료 (grouped data) : 양적자료를 구간별로 구분하여 범주형 자료로 변환한 자료. 

> 90이상 A, 90이하 80 이상 B...

```

```R
# 자료의 카테고리 숫자 확인
nlevels(iris$Species)
# [1] 3

# 자료의 카테고리 확인
levels(iris$Species)
# [1] "setosa"     "versicolor" "virginica" 

# table -> 관계요약
table(survey$Sex, survey$W.Hnd)
t1 = table(survey$Sex, survey$Smoke)

# prop.table -> 관계요약을 비율로 표현.
prop.table(t1) # 전체 합이 1이 되도록
prop.table(t1, 1) # 행의 합이 1이 되도록
prop.table(t1, 2) # 열의 합이 1이 되도록
```