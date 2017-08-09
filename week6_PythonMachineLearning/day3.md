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
분류 문제에서 그 분류들이 완벽하게 선형 분리되지 않는 경우, 
퍼셉트론은 데이터에 절대 수렴 불가능하다. 각 에포크에서 하나의 오분류라도 발견되는 경우,
계속하여 가중치가 업데이트 되고, 무한 반복에 빠지게 될 것이기 때문이다.

그래서 더 간단하지만 강력한 로지스틱 회귀를 생각해볼 수 있다.

로지스틱 회귀는 바이너리 분류를 위한 알고리즘으로 일반적인 회귀의 영역보다는, 
머신 러닝의 영역에 속한다고 보는 것이 옳다고 할 수 있다.

로지스틱 회귀는 가중치를 업데이트하는 비용함수와 활성함수로 sigmoid 함수를 사용한다.
활성함수의 return값은 특정 클래스에 속한다 / 속하지 않는다에 대한 확률이기 때문에,
문제의 참 / 거짓에 대한 예측 확률에 대해 머신러닝을 진행하는 알고리즘이라고 할 수 있다.

가중치를 업데이트하는 원리는 퍼셉트론과 동일(gradient discent)하지만, 
비용함수의 수식이 더욱 정교화 되었다. 일반적인 선형회귀에서의 비용함수는 SSE를 활용하였고, 
이는 2차방정식의 형태를 띠기 때문에 아주 유용한 수식이었다. 하지만 로지스틱회귀의 함수에서는
SSE가 계단식의 모양이 되어버려서 local minimum에 빠져버린다. 
이를 해결하기 위해서 logit 변환이라는 과정을 거치면, 비용함수가 다시 매끈한 모양으로 변한다.
파고들어보면 수식도 어렵지 않기 때문에 한번쯤 로지스틱 회귀의 비용함수를 구현해보는 것도 괜찮다.

귀분석을 이용한 분류 문제에서는 가중치를 업데이트하여 모델을 학습하는 과정에서
과적합의 문제가 발생하게 되는데, 이를 해결하기 위한 방법으로는 일반적으로 4가지 정도가 있다.

1. 훈련 데이터의 수를 충분히 넣는다.
2. 피쳐의 수를 줄인다. (feature selection)
3. 정규화를 이용하여 복잡도에 페널티를 부과한다.
4. 데이터의 차원을 축소한다. (feature scaling or extract)

이 중, 피처의 수를 줄이는 것과 데이터의 차원을 축소하는 것은 뒤에 나올 SBS기법과 PCA를 통해
자세하게 설명하겠다.

그렇다면 정규화를 이용하여 복잡도에 페널티를 부과하는 방법을 알아볼텐데, 정규화의 방법 역시
피처의 수를 줄이는 feature selection의 일부라고 볼 수 있다. (L1 정규화의 경우)

만약 회귀식이 과적화된 상황이고, 데이터에 적절한 함수는 2차 함수이며, 
실제로 회귀된 f(x)가 4차함수라고 하자. 회귀식은 다음과 같다.

f(x) = a + a1x + a2x^2 + a3x^3 + a4x^4

이 식에서 a3x^3 + a4x^4 의 부분 때문에 회귀식에서의 복잡도가 커지게 되었고, 과적합이 일어났다.
이 때, 비용함수에 대한 방법이 동일한 상태에서 a3과 a4에 매우 큰 값을 곱한다고 해보자.

이때 비용함수를 최소화해주는 학습을 진행하게 되면, minimize를 찾을 것이기 때문에 a3,a4가 거의
0에 가까운 값으로 수렴하게 될 것이다.

수식에 한정하여 얘기하면, 
간단하게는 비용함수에 w(가중계수)들의 절댓값을 더해주거나 곱을 더해주거나 하는 직관적인 방법을 수식에 사용한다.
이때 a3, a4가 매우 높은 값이라면 비용함수가 커지게 되므로 벌점을 부과한 꼴이 된다. 
(이 개념은 정말 천재적이고 직관적인 생각이다..)

이런 식으로 큰 가중치에 벌칙을 부과하는 방법이 정규화 방법이다.
L1, L2 등의 정규화 방법이 있고 Lasso, Ridge 등의 이름으로 흔히 불린다.
각각의 방법은 무엇을 페널티로 제공하는지에 따라 나뉘고, 특성이 약간씩 다르다.
자세한 내용은 나중에 공부할 예정이다.

하나 주목할 점은, 정규화 역시 피처 스케일링이 매우 중요하다는 점이다. 
모든 피처가 서로 비교 가능한 상태여야 피처들의 가중치에 대한 벌점 부과방식인 정규화 방식이
제대로 사용될 수 있을 것이다.

sklearn에서 사용하는 로지스틱 함수에서 C라는 파라미터가 정규화를 담당하는 파라미터인데,
값이 작을수록 정규화 강도를 증가시킨다는 것을 의미한다.
```

```python
from sklearn.linear_model import LogisticRegression

lr = LogisticRegression(C=1000.0, random_state=0) #C는 벌칙 상수.
lr.fit(X_train_std, y_train) #표준화된 데이터 적용

lr.predict_proba(X_test_std[0,:]) #해당 분류에 속할 확률값으로 결과 도출
y_pred_lr=lr.predict(X_test_std) #예측한 분류값을 보고싶을 때

print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_lr))

weights, params = [], []
corr01=[] #기존의 값에 정확도율 받아두기

#최적의 C값을 찾아보는 과정
for c in np.arange(0, 10): #np에서는 마이너스 값을 못 씀
    lr = LogisticRegression(C=10**c, random_state=0)
    lr.fit(X_train_std, y_train)
    y_pred_it=lr. predict(X_test_std)
    corr00=accuracy_score(y_test, y_pred_it)
    print('c= %d, Accuracy: %.2f' % (10**c, corr00))
    weights.append(lr.coef_[1])
    params.append(10**c)
    corr01.append(corr00) 
    #append: for 돌 때 마다(c값이 바뀔 때마다) 기존 값에 누적되서 저장되도록 함: 변화의 추이를 살펴볼 수 있다. 
```

> **2.3 SVM 적용**

>> SVM의 원리

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/10.png)

```
SVM은 퍼셉트론을 확장한 개념으로, 데이터를 선형으로 분리하는 최적의 선형 결정 경계를 찾는 알고리즘이다.
SVM은 선형 분류와 더불어 비선형 분류에서도 사용될 수 있다. 
비선형 분류를 하기 위해서 주어진 데이터를 고차원 특징 공간으로 사상하는 작업이 필요한데, 
이를 효율적으로 하기 위해 커널 트릭을 사용하기도 한다.
만약 훈련 데이터가 비선형 데이터라면, 이를 비선형 매핑(Mapping)을 통하여 고차원으로 변환시킨 뒤, 
새로운 차원에서의 최적의 결정 경계면을 찾는다. 이것이 커널 트릭을 사용한 것이다.

SVM을 나타낸 것이 위의 그림이다.
위의 그림은 두 분류를 하나의 결정 경계로 나눈 그림이다. 위에서는 두 개의 분류 경계면이 존재하는데, 
margin이 더 많이 남는 경계가 당연히 더 좋다.
SVM은 이러한 마진을 최대로 하는 분류 경계면을 찾는 알고리즘이라고 생각하면 된다.
그리고 margin을 결정하게 되는, 초평면(결정 경계면)과 가장 가까운 훈련용 샘플들이 바로 서포트 벡터이다.
(위의 그림에서 빨간 동그라미가 쳐져있는 샘플들)

초평면의 마진이 크면 클 수록, 낮은 일반화 오차를 갖는 경향이 있다는 것이고, 작은 마진을 가진 초평면의 경우는
오버피팅의 경향이 조금 더 크다는 것을 의미한다.

앞서 말한 것 처럼, 
비선형 데이터를 초평면을 최적으로 분리하기 위해서 SVM에서는 더 높은 차원으로 비선형 매핑을 하게된다.
이 이유는 다음의 그림으로 쉽게 이해할 수 있다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/11.png)

```
위의 그림을 보면 왼쪽의 경우 2차원에서는 선형 분리가 불가능하다. 하지만 이 데이터들을 3차원으로
매핑시키면 오른쪽처럼 분리가 가능해진다. 이러한 과정을 거쳐 비선형 영역을 선형으로 분리한다.
```

>> 초평면을 찾는 원리와 라그랑즈 승수법

```
초평면은 마진을 최대로 하는 것이 기본적인 대전제라고 할 수 있다.
그렇다면 어떻게 마진을 최대로 하는 초평면을 찾을 수 있는가?

음의 하이퍼 평면과 양의 하이퍼 평면의 두 식을 하나로 합치고, 영역에 속한다는 조건 등에서
나오는 변수들을 방정식으로 사용한다. 이때 방정식에 사용되는 변수들이 나오는 조건은
아래의 그림과 같이 convex hull 안에 분류 데이터들을 넣어놓고, convex hull에서의 수직 벡터와
새롭게 생성되는 초평면 사이의 가장 적절한 경계면이나 기울기를 찾아가는 과정에서 나온다.
왜냐하면 조건을 만족하는 초평면은 무수히 많을 수 있기 때문에, convex hull등의 개념을 이용하여
가장 적절한 초평면을 찾아가는 과정을 나오는 변수들을 방정식으로 사용해야 하기 때문이다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/13.png)

```
가장 효과적인 초평면을 찾아가면서 그룹간의 categorization을 할 때 발생하는 오류를 최소화해야 하는데,
이 과정에서 라그랑즈 승수법이라는 것을 사용해서 가장 적절한 변수들을 찾는다.

수학적으로 꽤나 복잡한 과정을 거치고, 
데이터의 convexity를 고려하면서 변수를 추출하고,
이후에 라그랑즈 승수법을 적용하여 최적의 초평면을 찾는다는 정도만 알아두면 되겠다.
```

>> 여유변수 파라미터를 사용하여 선형 분리를 조절

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/12.png)

```
이제 여유변수라는 파라미터가 필요해지게 된다. 여유변수는 말 그대로, 비선형의 분리 가능 데이터를 위한
선형 제약에 대한 여유값이다. SVM에서는 변수 C를 사용해서 오분류에 대한 벌칙을 제어할 수 있는데,
C가 커진다면, 오분류에 대한 벌칙을 강하게 주는 것이고 작아진다면, 벌칙을 약하게 주는 것이다.

위의 그림에서 왼쪽의 경우, C값을 크게 주어 오분류를 엄격하게 관리하고 있기 때문에
굉장히 쪼잔한(?) 초평면을 그리게 된다. 반면 오른쪽은 오분류 하나쯤은 관대하게 넘어가기 때문에
훨씬 좋은 느낌의 초평면을 그린다.
즉, C값이 증가할수록 바이어스는 증가하게 되고, 모델의 분산은 작아진다는 것이다.

이러한 관대한 SVM을 소프트 마진 분류법이라고 한다.
```

>> 파이썬 코드의 구현

```
아래의 파이썬 코드는, 선형 분리가 가능한 데이터에서의 SVM 분류 적용의 예시이다.
```

```python
from sklearn.svm import SVC

svm = SVC(kernel='linear', C=1.0, random_state=0)
# 로지스틱 회귀에서의 C와 반대의 개념. 모델을 조율해주는 값이라고 보면 됨.
svm.fit(X_train_std, y_train)
y_pred_svc = svm.predict(X_test_std)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_svc))

import matplotlib.pyplot as plt
import numpy as np

np.random.seed(0)
X_xor = np.random.randn(200, 2)
y_xor = np.logical_xor(X_xor[:, 0] > 0,
                       X_xor[:, 1] > 0)
y_xor = np.where(y_xor, 1, -1)

plt.scatter(X_xor[y_xor == 1, 0],
            X_xor[y_xor == 1, 1],
            c='b', marker='x',
            label='1')
plt.scatter(X_xor[y_xor == -1, 0],
            X_xor[y_xor == -1, 1],
            c='r',
            marker='s',
            label='-1')

plt.xlim([-3, 3])
plt.ylim([-3, 3])
plt.legend(loc='best')
plt.tight_layout()
# plt.savefig('./figures/xor.png', dpi=300)
plt.show()


svm = SVC(kernel='rbf', C=10.0, random_state=0, gamma=0.10)
svm.fit(X_xor, y_xor)
y_pred_ksvc = svm.predict(X_xor)
print('Accuracy: %.2f' % accuracy_score(y_xor, y_pred_ksvc))
```

>> 비선형 데이터에서의 커널 트릭 사용

```
SVM으로 문제를 해결함에 있어서, XOR 문제처럼 데이터가 비선형의 그룹 모양을 하고 있을 때,
초평면을 이용하여 분리하는 것이 불가능한 경우가 있다.
이 경우에 위에서 언급한 커널 트릭이라는 개념으로 해결이 가능하다.

커널 트릭은, input data들을 특정 커널을 이용해서 새로운 output처럼 만들어내는 과정을 거친다.
이 때, 새로운 data를 배출해내는 커널로써 RBF나 가우시안 커널을 주로 사용한다.

위의 SVM 클래스를 사용하는 python 코드에서

svm = SVC(kernel='linear', C=1.0, random_state=0)

라고 되어있는 부분의 의미를 살펴보자. kernel='linear'라는 것의 의미는, 디폴트 커널 트릭이
linear라는 것이다. 즉, 커널 트릭을 사용하지 않는다는 것과 일맥상통하다.
커널 트릭을 사용하기 위해서는 kernel="rbf"와 같이 커널 파라미터만 바꿔주면 된다.

결론적으로, SVM 알고리즘을 적용하여 분류문제를 해결하는 상황에서는 반드시 EDA 과정에서 
데이터가 선형 분리가 가능한지 여부를 확인하고, 커널 트릭에 대해서 지정해줘야 한다.
```

> **2.4 의사결정트리 적용**


```python
### 의사결정 트리

from sklearn.tree import DecisionTreeClassifier

tree = DecisionTreeClassifier(criterion='entropy', max_depth=3, random_state=0)
tree.fit(X_train, y_train)
tree

from sklearn.tree import export_graphviz
import pydotplus
from IPython.display import Image

dot_data = export_graphviz(tree, 
                out_file=None, 
                feature_names=['petal length', 'petal width'])

graph = pydotplus.graph_from_dot_data(dot_data)
Image(graph.create_png())

y_pred_tr = tree.predict(X_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_tr))
```

> **2.5 랜덤 포레스트 적용**

```python
from sklearn.ensemble import RandomForestClassifier

forest = RandomForestClassifier(criterion='entropy',
                                n_estimators=10, 
                                random_state=1,
                                n_jobs=2)
forest.fit(X_train, y_train)

y_pred_rf = tree.predict(X_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_rf))
```

> **2.6 knn 적용**


```python
### knn 적용

from sklearn.neighbors import KNeighborsClassifier

knn = KNeighborsClassifier(n_neighbors=5, p=2, metric='minkowski')
knn.fit(X_train_std, y_train)
y_pred_knn = tree.predict(X_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_knn))
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
import pandas as pd
from io import StringIO

df = pd.DataFrame([
            ['green', 'M', 10.1, 'class1'], 
            ['red', 'L', 13.5, 'class2'], 
            ['blue', 'XL', 15.3, 'class1']])

df.columns = ['color', 'size', 'price', 'classlabel']
df

### 범주형 데이터를 맵핑하는 과정
size_mapping = {
           'XL': 3,
           'L': 2,
           'M': 1}

df['size'] = df['size'].map(size_mapping)
df

### 역변환
inv_size_mapping = {v: k for k, v in size_mapping.items()}
df['size'] = df['size'].map(inv_size_mapping)
df

### 패키지를 이용하는 방법
from sklearn.preprocessing import LabelEncoder

class_le = LabelEncoder()
y = class_le.fit_transform(df['classlabel'].values)
class_le.inverse_transform(y)
# class_le 라는 레이블 인코더 오브젝트에 변환 전, 후의 정보를 모두 가지고서 편하게 변환이 가능.

### 더미변수 생성 - one hot encoder
from sklearn.preprocessing import OneHotEncoder

X = df[['color', 'size', 'price']].values
X[0]
X[:, 0]

color_le = LabelEncoder()
X[:, 0] = color_le.fit_transform(X[:, 0])
X

ohe = OneHotEncoder(categorical_features=[0])
ohe.fit_transform(X).toarray()

### 더미변수 생성 함수
pd.get_dummies(df[['price', 'color', 'size']])
```


-----------------------


#### **4. 피처 선택**

> **4.1 L1 정규화가 있는 희소 솔루션**

> **4.2 연속형 피처 선택**

```
SBS를 이용한 방법이 있고, 재귀적 후진 제거법 등 다양한 방법이 있다.
여기서는 SBS만 코드로 실습해보았다.
```

> **4.3 부스팅 기법에서의 피처 중요도**

```
랜덤 포레스트를 활용한 피처 중요도의 평가를 나타내보았다.
```