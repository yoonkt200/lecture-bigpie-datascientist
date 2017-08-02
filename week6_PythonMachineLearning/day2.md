# 2일차 


-----------------------


#### **1. 머신러닝의 핵심 원리**


> **1.1 인공 뉴런의 개념**

```
머신 러닝과 관련된 학문은 초기에 인공 뉴런을 표방하는 것으로 시작되었다.
뇌가 어떻게 일하는지를 이해하려는 노력의 산물이 바로 인공 뉴런이다.

뉴런은 뇌에서 서로 연결되어있는 신경 세포를 의미하는데, 이를 알고리즘으로 해부하면 다음과 같다.
하나하나의 신경세포는 바이너리 출력을 갖는 간단한 논리 게이트를 가지고 있다.
신경세포가 다음 신경세포로 신호를 보내는 임계치를 판단하는 것이 바로 활성함수의 개념이다.

이 활성함수의 최적의 가중계수를 자동으로 찾는 것이 머신 러닝과 인공 뉴런의 핵심이라고 할 수 있다.
활성함수 여러개의 output이 다시 활성함수의 input으로 들어가고, 
마치 tree 구조에서 parent 노드에 도달하는 것과 유사한 흐름으로 예측치 Y에 도달하게 된다.

예측치 Y가 실제의 Y값과 다르다면, 각각의 활성함수들의 계수에 문제가 있는 것이다.
비용함수를 최소화하기 위해 활성함수들의 계수를 조정하는 과정을 거치게 되는데, 
이 과정이 머신 러닝에서의 학습 과정이다.
```

> **1.2 퍼셉트론**

```
인공뉴런의 시작으로 퍼셉트론이라는 것이 있다.
퍼셉트론은 학습 규칙을 가지고 있는데, 이것의 메인 아이디어는 하나의 뉴런을 작동시킬지 말지에 대해
최적의 가중계수를 학습한 뒤 그것을 입력 피처에 곱하는 것이었다. 

이 개념은 주로 분류에 사용되었으며, 간단한 예를 들어 설명하면 다음과 같다.
만약 두 가지로 분류를 하는 문제가 있다고 하자. 그 결과값은 1,-1 두 가지 이다.
여기서 입력값 x와 가중 벡터(가중 계수) w가 선형 조합을 취하는 수식을 활성함수 f(z)라고 한다.
여기서의 z는 순 입력(new input function)이라고 한다. (z = w1x1 + w2x2 + ...)
만약 활성함수에 대한 출력값이 만약 특정 임계값을 넘어선다면 결과값은 1이 되는 것이고, 아니라면 -1이 되는 것이다.

이것이 단일 뉴런의 작동 방식이다.
바로 이런 작동 원리 위에서, 퍼셉트론 규칙의 가중치를 업데이트 할 수 있다.

1. 가중치를 0 혹은 그에 준하는 작은 값으로 초기화한다.
2. 훈련 데이터에 대하여 최종 출력 값을 계산한다. 
	(가중치를 아직 업데이트 하지 않는 원시 수식에서 데이터와 라벨 쌍이 몽땅 들어온다면 온라인 방식, 
	나뉘어져 들어온다면 배치 방식이라고 부른다.)
3. 가중치를 업데이트한다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/6.png)

```
이제 가중벡터 내에서 업데이트 되는 각각의 가중치 wj를 수식으로 표현하면 다음과 같다.

wj = wj + Δwj

가중치를 업데이트 하는 데 사용된 Δwj값은 퍼셉트론의 학습 규칙에 의해 계산되는데, 이부분이 학습의 핵심이다.

Δwj = μ(y - y_pred) * xi

여기서 μ은 학습률을 나타내는데, 수식적으로 생각해본다면 학습률이 크면 자연히 Δwj의 절대값이 커질 수 밖에 없을 것이다.
또한, 오분류에 대해서는 반대 방향으로 시프트 현상이 일어날 것임이 매우 직관적이다.

만약 위처럼 예를 든 분류같이, 
분류 대상이 선형적으로 명확히 분류가 가능하고 학습률이 충분히 작다면 퍼셉트론은 결국 수렴하게 될 것이다.
물론 오분류 허용 임계치를 설정해 주지 않으면 무한히 이를 반복할 것이다.

선형적으로 분류가 가능하다는 것은, 
그래프로 표현하면 평면상의 두 분류를 하나의 직선을 그어서 하는것이 가능하다는 것이고,
수식적으로는 최대 차수가 일차항인 단일 함수를 통해 두 분류를 해낼 수 있다는 것이다.
```

> **1.3 퍼셉트론의 구현**

```
python machine learning 교재에서는 퍼셉트론을 직접 구현하는 예제를 삽입해 두었다.
아마 실전에서 퍼셉트론을 직접 구현할 일은 없겠지만, 
가중계수를 코딩으로 직접 업데이트 해보는 것은 제법 의미가 있는 일인 것 같다.
```

```python
import numpy as np


class Perceptron(object):

    def __init__(self, eta=0.01, n_iter=10):
        self.eta = eta
        self.n_iter = n_iter
        # 퍼셉트론의 학습률과 가중치 업데이트 반복 회수

    def fit(self, X, y):
        self.w_ = np.zeros(1 + X.shape[1]) 
        # a.shape[k] : a가 n차원의 데이터일때, k차원의 attribute 숫자를 리턴해줌.
        # np.zeros(a) : a가 int라면, aX1 일차원 행렬을 생성해줌. a가 shape=(b,c)라면 bXc 행렬을 생성해줌.
        self.errors_ = []

        for _ in range(self.n_iter):
            errors = 0
            for xi, target in zip(X, y):
                update = self.eta * (target - self.predict(xi))
                self.w_[1:] += update * xi
                self.w_[0] += update
                errors += int(update != 0.0)
            self.errors_.append(errors)
            # error는 iter의 각 단계에서 얼마나 error가 발생했는지 보기 위함.
        return self

    def net_input(self, X):
        return np.dot(X, self.w_[1:]) + self.w_[0]
        # np.dot(a,b) : a,b 행렬의 곱. 내적값 --> a.dot(b) == np.dot(a,b)

    def predict(self, X):
        return np.where(self.net_input(X) >= 0.0, 1, -1) 
        # np.where(a, b, c) : 조건 a에 따라 b,c로 결과값 할당
```


> **1.4 에이다라인과 학습의 수렴**

```
에이다라인이 퍼셉트론보다 발전된 점은, 비용함수를 따로 정의하고 이를 최소화 하는 것을 목표로 하는 점이다.
퍼셉트론이 오차를 처리하는 방법은, 실제 값과 예측 값의 차이를 단순 보정하여 업데이트에 이용하는 것이었다.
하지만 에이다라인의 경우 비용함수를 더욱 발전된 방법으로 정의한다.

그 예가 바로 Gradient Descent이다.
비용함수를 SSE으로 정의하였다면, 이 비용함수는 2차함수이기 때문에 미분이 가능하다.
이 함수의 또 다른 특징으로는 볼록성이다. 

미분이 가능하며 볼록성을 띠는 SSE 2차함수는 U자형 모양을 띠게 되는데, 그곳이 극소점이다.
이 알고리즘은 그래디언트 디센트라는 이름 자체에서 오는 느낌 그대로,
미분을 통해 점진적으로 오차제곱합이 극소값이 되는 곳을 찾는다.

퍼셉트론과 에이다라인은 굉장히 유사한 알고리즘이지만, 
비용함수 최소화에 의해 가중치가 갱신되는 부분이 다르다.
이 내용은 수식으로 봐도, 피부로도 직접적으로 와닿지 않기 때문에 코드로 비교해보면 훨씬 와닿는다.
```

> **1.5 에이다라인의 구현**

```python
class AdalineGD(object):

    def __init__(self, eta=0.01, n_iter=50):
        self.eta = eta
        self.n_iter = n_iter

    def fit(self, X, y):
        self.w_ = np.zeros(1 + X.shape[1])
        self.cost_ = []

        for i in range(self.n_iter):
            output = self.net_input(X)
            errors = (y - output)
            # 퍼셉트론과 달리, 모든 입력데이터의 결과값을 1 iter에 한번에 구한 뒤,
            # 입력 레이블과의 오차도 모두 구함.
            self.w_[1:] += self.eta * X.T.dot(errors)
            self.w_[0] += self.eta * errors.sum()
            # 퍼셉트론과의 차이는 데이터가 한번에 들어간다는 점.
            cost = (errors**2).sum() / 2.0
            self.cost_.append(cost)
        return self

    def net_input(self, X):
        return np.dot(X, self.w_[1:]) + self.w_[0]

    def activation(self, X):
        return self.net_input(X)

    def predict(self, X):
        return np.where(self.activation(X) >= 0.0, 1, -1)
```

```
이러한 머신러닝의 방법에서 에포크를 잘못 조정하게 되면,
평생토록 가중계수를 수렴시키지 못하거나(...) 아예 SSE값이 안드로메다로 가버릴 수 있다.
그래서 에포크를 항상 로그로 찍어서 관찰한 뒤 계수를 조정하거나, 그래프를 그려보는 것이 바람직하다.
```

```python
fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(8, 4))

ada1 = AdalineGD(n_iter=10, eta=0.01).fit(X, y)
ax[0].plot(range(1, len(ada1.cost_) + 1), np.log10(ada1.cost_), marker='o')
ax[0].set_xlabel('Epochs')
ax[0].set_ylabel('log(Sum-squared-error)')
ax[0].set_title('Adaline - Learning rate 0.01')

ada2 = AdalineGD(n_iter=10, eta=0.0001).fit(X, y)
ax[1].plot(range(1, len(ada2.cost_) + 1), ada2.cost_, marker='o')
ax[1].set_xlabel('Epochs')
ax[1].set_ylabel('Sum-squared-error')
ax[1].set_title('Adaline - Learning rate 0.0001')

plt.tight_layout()
# plt.savefig('./adaline_1.png', dpi=300)
plt.show()
```

```
그래프를 보면, 0.01 에포크에서는 비용함수의 값이 안드로메다로 여행을 떠난다.
이는 에포크의 값이 잘못된 탓도 있지만, 데이터가 표준화되지 않았기 때문이다.
표준화를 시켜준 뒤 다시 그려보면 이번에는 비용함수의 값이 제자리를 찾게 된다.
```

```python
X_std = np.copy(X)
X_std[:,0] = (X[:,0] - X[:,0].mean()) / X[:,0].std()
X_std[:,1] = (X[:,1] - X[:,1].mean()) / X[:,1].std()

ada = AdalineGD(n_iter=15, eta=0.01)
ada.fit(X_std, y)

plot_decision_regions(X_std, y, classifier=ada)
plt.title('Adaline - Gradient Descent')
plt.xlabel('sepal length [standardized]')
plt.ylabel('petal length [standardized]')
plt.legend(loc='upper left')
plt.tight_layout()
# plt.savefig('./adaline_2.png', dpi=300)
plt.show()

plt.plot(range(1, len(ada.cost_) + 1), ada.cost_, marker='o')
plt.xlabel('Epochs')
plt.ylabel('Sum-squared-error')

plt.tight_layout()
# plt.savefig('./adaline_3.png', dpi=300)
plt.show()
```

> **1.6 미니배치 방식의 그래디언트 디센트 구현**

```
위에서 구현한 그래디언트 디센트는 배치 방식이다.
온라인 방식의 그래디언트 디센트는 흔히 확률적 그래디언트 디센트라고 불리는데,
이 방식을 이용하면 계산비용이 극적으로 감소하며, 데스크탑과 심신의 안정을 도모할 수 있다.

확률적 그래디언트 디센트는 가중치 업데이트의 사이클이 훨씬 짧기 때문에
더 빠르게 수렴에 이르게 된다. 더 빠르게 수렴이 되는 만큼 국지적 최소값으로 빠질 수가 있다.

이러한 단점을 보완하기 위해 그래디언트 디센트에서의 학습률을 동적으로 대체시킨다.
시간이 지남에 따라 감소하는 적응적 학습률을 사용하는데, 본 글에서는 사용하지는 않기로 한다.

이제 온라인 방식의 그래디언트 디센트의 소스코드를 훑어보자.
input data만 나눠놓고, 업데이트하는 부분만 나눠놓으면 사실 별로 손 볼 부분도 없다.
```

```python
from numpy.random import seed

class AdalineSGD(object):

    def __init__(self, eta=0.01, n_iter=10, shuffle=True, random_state=None):
        self.eta = eta
        self.n_iter = n_iter
        self.w_initialized = False # 초기화와 관련된 변수
        self.shuffle = shuffle # chunk data의 순서를 섞어주는 역할
        if random_state:
            seed(random_state)
        
    def fit(self, X, y):
        self._initialize_weights(X.shape[1]) # 가중계수 초기화
        self.cost_ = []
        for i in range(self.n_iter):
            if self.shuffle:
                X, y = self._shuffle(X, y)
            cost = []
            for xi, target in zip(X, y):
                cost.append(self._update_weights(xi, target))
            avg_cost = sum(cost)/len(y)
            self.cost_.append(avg_cost)
        return self

    def partial_fit(self, X, y): # 들어오는 partial data에 대해서 바로 학습, 업데이트
        if not self.w_initialized:
            self._initialize_weights(X.shape[1])
        if y.ravel().shape[0] > 1:
            for xi, target in zip(X, y):
                self._update_weights(xi, target)
        else:
            self._update_weights(X, y)
        return self

    def _shuffle(self, X, y): # chunk data의 순서를 섞어주는 역할
        r = np.random.permutation(len(y))
        return X[r], y[r]
    
    def _initialize_weights(self, m): # 가중계수 초기화
        self.w_ = np.zeros(1 + m)
        self.w_initialized = True
        
    def _update_weights(self, xi, target): # 업데이트를 작은 단위로 바로 시행
        output = self.net_input(xi)
        error = (target - output)
        self.w_[1:] += self.eta * xi.dot(error)
        self.w_[0] += self.eta * error
        cost = 0.5 * error**2
        return cost
    
    def net_input(self, X):
        return np.dot(X, self.w_[1:]) + self.w_[0]

    def activation(self, X):
        return self.net_input(X)

    def predict(self, X):
        return np.where(self.activation(X) >= 0.0, 1, -1)
```

-----------------------


#### **2. 오버피팅과 학습방식에 대한 개념**


> **2.1 신경망 등에서의 오버피팅**
```
신경망에서도 당연히 오버피팅이 발생한다.

오버피팅 만물보존의 법칙(?)에 의거하면, 어떤 알고리즘에서든 오버피팅은 발생하는데
공통적으로 적용되는 해결법들은 있는 것 같다.

1. 훈련 데이터를 늘린다
2. 피처를 정규화 / 표준화 시켜준다
3. 피처를 선택하여 제거하거나, 페널티를 준다.
4. 데이터의 차원을 축소한다

이 외에, 알고리즘별로 발생하는 특징들과 해결법들이 유수하게 존재할 것이다.

아마도 신경망 알고리즘에서의 오버피팅은 활성함수를 가지고 있는 각각의 뉴런들이 
훈련 데이터들에 매우 과적합이 되어 있는 상태를 말할 것이다.

딥 러닝으로 발전되어지기 이전의 인공신경망에서는 이러한 문제점을 
- 사전훈련을 통해 initial weight를 신중하게 고르는 방법
- unsupervised RBM
- backpropagation

등으로 어떻게든 해결하기 위해 노력했었다. 하지만 성능은 썩 좋지는 못하였다.
그러나 딥 러닝으로 패러다임이 전환되면서, 
backpropagation 기법도 발전하였고 무엇보다 dropout이라는 새로운 방법이 발견되었다.
이제는 신경망에서의 오버피팅은 거의 dropout으로 해결이 가능하며 가장 많이 사용하는 기법이 되었다.
```

> **2.2 dropout의 개념**

```
드롭아웃은 네트워크 학습에서 오버피팅을 막기 위한 방법으로, 뉴럴 네트워크가 학습중인 경우에
마치 앙상블 기법처럼 랜덤하게 뉴런을 골라서 학습을 진행한다. (하지만 앙상블처럼 최종 투표를 하지는 않는다)
오버피팅을 막기 위해 몇몇개의 뉴런은 일부러 제거한다는 것이다.
이 드롭아웃 레이어의 위치에 따라서도 성능이 달라지는 경우가 있지만, 대부분의 경우는 큰 차이가 없다.

드롭아웃은 워낙에 쉽고 직관적인 방법이기 때문에, 아래의 두 이미지만 보아도 별다른 설명 없이 이해가 가능하다.
```

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/7.png)

![](https://raw.github.com/yoonkt200/DataScience/master/week6_PythonMachineLearning/week6_images/8.png)

> **2.3 batch processing VS online processing**

```
일반적으로 대중화된, 아이리스 데이터 등으로 데스크탑에서 손쉽게 돌려볼 수 있는 머신러닝 자료들은
데이터를 통째로 IDE로 불러들인 다음 메모리상에 올려두고 작업하는 방식이었을 것이다.

모델을 학습함에 있어서도 모든 트레이닝 데이터셋의 결과값을 한번에 구한 뒤, 데이터셋과 쌍이 맞는
레이블과의 차이를 구해서 비용함수를 한번에 개선하는 방식의 학습을 n-iterative 하게 진행하였을 것이다.

하지만 머신러닝을 진행함에 있어서 데이터의 크기는 언제든지 늘어나게 된다. 아마 실전의 대부분은,
한 개의 데스크탑에서 불러올 수 없는 양의 데이터가 대부분일 것이다. 
이런 경우 R 혹은 Python등의 툴로는 데이터를 메모리에 올려놓고 한번에 처리하기가 힘들어진다.
그렇게 되면 모델을 학습하는 경우에도 트레이닝 데이터를 쪼개서 여러 번 넣어야 하고, 
프로그래머 식으로 말하자면 전자는 for loop를 한번 돌지만 후자는 
'트레이닝 데이터들' 이라는 loop가 하나 더 생기는 것이라고 할 수 있다.

전자의 경우를 일괄 처리 방식, 일명 batch 방식이라고 한다. 후자는 online processing 혹은 mini batch라고 한다.

딥러닝의 영역으로 들어가게 된다면, 데이터의 양이 기하급수적으로 증가하기 때문에(딥러닝까지 가지 않더라도)
mini batch 시스템을 이용하여 모델을 학습하는 것은 거의 필수적인 일이 되어버렸다.

online processing을 진행하는 python 코드는 다음 링크를 참조하길 바란다.
```

http://yamalab.tistory.com/34