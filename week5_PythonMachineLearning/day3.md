# 3일차 


-----------------------


#### **1. 머신러닝을 위한 간략한 데이터 전처리**


> **1.1 데이터 분리, 표준화**

```
label이 있는 지도학습의 경우, 모델을 학습하는 용도의 Training dataset과 학습한 모델을 평가하는 용도인
Test dataset이 필요하다. sklearn.model_selection 모듈에서는 이러한 작업을 함수 하나로 해결해준다.

물론 데이터 샘플링은 그 자체로도 큰 이슈이기 때문에, 
정밀한 프로젝트를 진행할 때 함수 하나로 해결하는 것은 좋지 않다. 하지만 간단한 모델을 만들 때 유용하다.
```

```python
from sklearn import datasets
from sklearn.model_selection import train_test_split

iris = datasets.load_iris()
X = iris.data[:, [2, 3, 4]]
y = iris.target

# 자동으로 데이터셋을 분리해주는 함수 (random_state는 난수 시드
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
```

```
sklearn.preprocessing 모듈에서는 데이터 standardization을 자동으로 해주는 함수를 제공한다.
decision 트리 등의 데이터 상호단위가 중요하지 않은 경우의 모델링을 제외하면, 
대부분의 모델링에서는 표준화 작업을 해주어야 한다. sklearn 모듈에서는 이러한 작업 역시 간단하게 제공한다.
```

```python
from sklearn.preprocessing import StandardScaler

sc = StandardScaler()
sc.fit(X_train) # 평균과 표준편차를 구해주는 함수

# 표준화 함수
X_train_std = sc.transform(X_train)
X_test_std = sc.transform(X_test)
```

-----------------------


#### **2. 간단한 머신러닝 모델 학습**



> **2.1 간단한 Perceptron모델 학습**

```
sklearn을 통해 앞서 구현해봤던 Perceptron을 실행해 볼 수 있다.
```

```python
from sklearn.linear_model import Perceptron

ppn = Perceptron(n_iter=40, eta0=0.1, random_state=0)
# random state는 weight의 초기값들을 랜덤으로 설정해주는 시드값.

ppn.fit(X_train_std, y_train) # 퍼셉트론 모델 학습
y_pred = ppn.predict(X_test_std) # test dataset으로 y값 예측

# 예측이 얼마나 잘 되었는지 평가
print('Classified samples: %d' % (y_test == y_pred).sum())
print('Misclassified samples: %d' % (y_test != y_pred).sum())
from sklearn.metrics import accuracy_score
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred))
```

> **2.2 로지스틱 회귀의 적용**

```
로지스틱 회귀는 바이너리 분류를 위한 알고리즘으로 일반적인 회귀의 영역보다는, 
머신 러닝의 영역에 속한다고 보는 것이 옳다고 할 수 있다.

로지스틱 회귀는 가중치를 업데이트하는 활성함수로 sigmoid 함수를 사용한다.
활성함수의 return값은 특정 클래스에 속한다 / 속하지 않는다에 대한 확률이기 때문에,
문제의 참 / 거짓에 대한 예측 확률에 대해 머신러닝을 진행하는 알고리즘이라고 할 수 있다.

가중치를 업데이트하는 원리는 퍼셉트론과 동일(gradient discent)하지만, 
구체적인 수식을 따지고 들어가기엔 다소 어렵다. 이 영역은 수학자의 영역에 더 가깝다.

??? 파라미터의 의미
```

```python
```

> **2.3 SVM 적용**

```
커널기법이 매우 중요.
선형으로 해결하지 못하는 데이터셋의 경우, 커널 기법을 이용하여 차원을 변환한 뒤 문제를 해결함.
문제를 해결한 뒤 다시 차원을 변환하는 것을 맵핑한다고 함.
```

```python
```

> **2.4 의사결정트리 적용**


```python
```

> **2.5 knn 적용**


```python
```


-----------------------


#### **3. 데이터 전처리 기법**


> **3.1 연속형 데이터 처리**

```
파이썬을 이용하여 데이터를 처리할 때 가장 유용한 모듈인 pandas를 이용한다.
결측값을 처리하는 과정은 여러 가지가 있지만, 크게는 버리는 것과 보정하는 것으로 나뉜다.
```

>> 버리는 방법
```python
import pandas as pd
from io import StringIO

csv_data = '''A,B,C,D
1.0,2.0,3.0,4.0
5.0,6.0,,8.0
10.0,11.0,12.0,'''

df = pd.read_csv(StringIO(csv_data))
df

df.isnull().sum() # 열 별로 null의 갯수 체크
df.dropna(how='all') # 모든 열이 NaN인 행만 제거
df.dropna(axis=1) # axis는 열을 지울건지, 행을 지울건지에 관한 것.
df.dropna(axis=0)
df.dropna(thresh=4) # 행 기준, 4개가 다 있는 데이터만 살림.
df.dropna(subset=['C']) # column=C만 결측 처리
```

>> 보정하는 방법
```python
from sklearn.preprocessing import Imputer

imr = Imputer(missing_values='NaN', strategy='mean', axis=0) 
# axis : 0은 열, 1은 행
imr = imr.fit(df)
imputed_data = imr.transform(df.values)
imputed_data
```

> **3.2 범주형 데이터 처리**

```python
```