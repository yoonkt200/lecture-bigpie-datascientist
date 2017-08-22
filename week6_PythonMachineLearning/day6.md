# 6일차 


-----------------------


#### **1. 파이썬에서 회귀분석으로 연속형 목표변수 예측하기**

```
회귀 모델이란, 연속형 스케일을 가진 목표변수를 예측하는 방법 중에 한가지이다.
지도학습의 일종으로 변수 간 관계, 연관성을 파악하기에 좋다.
가장 단순하면서도 가장 강력한 예측 방법으로 알려져 있다.
```

> **1.1 심플 선형회귀**

```
심플 선형회귀는 단일 설명변수 하나와 연속형 반응변수간의 관계를 모델링하는 것이다.

간단하게,
y = 𝑤0 + 𝑤1 * 𝑥 의 관계식으로 정의할 수 있다.

중요한 것은 𝑤1 으로 설명변수의 계수인데, 
설명변수와 목표변수간의 관계에서는 이러한 설명변수의 계수가 중요하다.

관측치들 사이에서의 residual(잔차)를 최소화하는 위치를 찾는것이 선형 회귀에서의 최적-피팅이라고 할 수 있다.
```

> **1.2 회귀분석에 앞선 EDA**

```
탐색적 데이터 분석을 통해 데이터의 이상치 존재 여부, 데이터의 분포, 피처간의 상관관계 등을 살펴봐야 한다.

EDA를 위한 간단한 파이썬 시각화 모듈로, matplotlib, seaborn 등이 있다.
아래의 코드는 변수간의 상관관계를 두 가지 방법으로 시각화함으로써 EDA를 진행한다.

두 번째 그래프의 상관행렬은, 피어슨 상관계수를 포함하는 제곱행렬이다.
(피처간의 선형적 의존성을 -1~1로 나타내는 방법.)
```

```python
import pandas as pd

df = pd.read_csv('https://raw.githubusercontent.com/rasbt/python-machine-learning-book/master/code/datasets/housing/housing.data',
                  header=None, sep='\s+')

df.columns = ['CRIM', 'ZN', 'INDUS', 'CHAS', 
              'NOX', 'RM', 'AGE', 'DIS', 'RAD', 
              'TAX', 'PTRATIO', 'B', 'LSTAT', 'MEDV']
df.head()


%matplotlib inline
import matplotlib.pyplot as plt
import seaborn as sns
sns.set(style='whitegrid', context='notebook')
cols = ['LSTAT', 'INDUS', 'NOX', 'RM', 'MEDV']

sns.pairplot(df[cols], size=2.5)
plt.tight_layout()
plt.show()


import numpy as np
cm = np.corrcoef(df[cols].values.T)
sns.set(font_scale=1.5)
hm = sns.heatmap(cm, 
            cbar=True,
            annot=True, 
            square=True,
            fmt='.2f',
            annot_kws={'size': 15},
            yticklabels=cols,
            xticklabels=cols)

plt.tight_layout()
plt.show()
```

> **1.3 모델의 학습과 회귀 파라미터 추정 방법**

```
최적-피팅을 위해서는 회귀선의 파라미터들을 최적으로 추정해내야 한다.
그 방법으로 샘플 관측치들의 수직거리의 제곱의 합을 이용하는 순위형 최소제곱(Ordinary Least Square, OLS) 방법을 사용할 수 있는데,
가장 대표적인 방법으로 그래디언트 디센트(Gradient Descent)가 있다.

퍼셉트론에서 한 단계 발전한 에이다라인에서 처음으로 OLS 방법을 이용한 머신 러닝의 패러다임을 제시했던 것을 기억해보자.
에이다라인 모델 학습의 하이라이트는 비용함수를 이용해서 cost를 최소화 하는 것에 있었다.
회귀분석 역시 마찬가지다. 제곱오차합 등을 이용해서 비용함수를 구성한 뒤, 이를 gradient descent 등의 방법으로 최소화한다.
```