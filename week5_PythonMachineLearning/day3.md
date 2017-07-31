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