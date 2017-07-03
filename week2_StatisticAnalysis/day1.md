# 1일차 


-----------------------


#### **1. 개발환경 구축**


> **1.1 기본 설치** : Java 최신버전과 R, Rstudio 설치.

- cmd, terminal 에서 javac 명령어로 자바 설치 및 path 확인

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

- 통계에서 추정이란 표본으로부터 모집단의 성질을 추정해내는 것. 확률 개념이 중요.

- 통계란 또한 수 많은 데이터에서 대표치(평균 등)을 뽑아내는 것.

- 대표치를 뽑아 낼 때, 이상치등의 여부를 확인하고 처리해야 함.

- 분산이란 흩어진 정도를 나타냄.

- 참고 : 가중평균

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

- 표본 평균의 특징

```

- 잔차제곱합이 다른 유형의 위치척도에 비하여 작다.

- 자료 안의 극단값의 유무에 따라 큰 차이를 보인다.

- 모든 측정값을 반영한다.

```

- 절사 평균

```

자료값이 큰 쪽과 작은 쪽에서 각각 몇개씩 제거한 나머지 자료의 평균. 

--> 극단값 제거한 평균. 보편적으로 5%, 10% 정도의 절사를 함.

```

- 변동 계수

```

- 평균을 중심으로 한 상대적인 산포의 척도.

- 측정 단위가 동일하지만 평균이 큰 차이를 보이는 두 자료집단 또는 

- 측정단위가 서로 다른 두 자료집단에 대한 산포의 척도를 비교할 때 많이 사용한다.

- 예를 들어, 신생아의 몸무게와 산모의 몸무게(단위는 같으나 평균의 차가 큰 경우)

- 키와 몸무게의 경우(단위가 다른 경우)

```

- 위치 척도

원자료를 표준화하거나, 100분위수 또는 4분위수처럼 상대적인 자료로 변환한 척도.

- z 점수

```

- z점수 혹은 표준점수라고 부른다.

- 각 자료값을 평균을 중심으로 한 상대적인 위치로 변환한 척도이다.

- 평균을 0으로 대치하고, z-점수가 양수이면 평균보다 크고 음수이면 평균보다 작다.

- 보통 -3~3 사이에 있으며, 그 밖은 이상값으로 본다.

- z-점수의 1점 단위를 시그마라고 부름. 

※ 6시그마 운동은 -6~6 사이에 제품을 놓자는 운동.

```

- 선형성

```

- 반응변수와 응답변수의 반응성을 선형성이라고 함. -> plot이나 산점도로 대략 파악함.

- 자료점들이 직선에 가까우면 선형적이고, 직선을 중심으로 넓게 나타나면 선형성이 약하다.

```

- 공분산

```

- 두개의 확률변수의 상관정도를 나타내는 것.

- 두 변수 사이의 관계에 대한 형태, 방향 그리고 밀접관계의 강도 등을 알 수 있다.

- 모공분산(population covatiance) : 독립변수의 평균편차와 응답변수의 평균편차의 곱에 대한 평균이다.

- 표본공분산(sample covariance) : 독립변수의 평균편차와 응답변수의 평균편차의 곱을 n-1로 나눈것.

```

