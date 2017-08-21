# 6일차 


-----------------------


#### **1. 파이썬에서 회귀분석으로 연속형 목표변수 예측하기**

```
연속형 목표변수를 가진 회귀분석과 관련된 개념은 이미 정리가 끝났기 때문에 넘어간다.
파이썬에서는 개념을 구현해보는 과정에만 집중하기로 한다.

유명한 데이터셋중 하나인 하우징 데이터를 이용하여 선형회귀 모델을 구현해볼 것이다.
```

> **1.1 EDA**

```
먼저 데이터셋을 로드한 뒤, 탐색적 데이터 분석인 EDA(Exploratory Data Analysis)를 진행한다.

가장 먼저 산점도를 통해 데이터 피처 쌍 간의 관계를 플롯으로 살펴본다.
```

```python
import random
import webbrowser
import pytagcloud # requires Korean font support
import sys
from collections import Counter

def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text

def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]

C_docs = [(tokenize(row['contents']), row['판매금액_z_rank']) for index, row in junggo_C.iterrows()]

import nltk
token = [t for d in C_docs for t in d[0]]

r = lambda: random.randint(0,255)
color = lambda: (r(), r(), r())

def get_tags(text, ntags=50, multiplier=1):
    count = Counter(text)
    return [{ 'color': color(), 'tag': n, 'size': int(c*multiplier*0.03) }\
                for n, c in count.most_common(ntags)]

def draw_cloud(tags, filename, fontname='Korean', size=(800, 600)):
    pytagcloud.create_tag_image(tags, filename, fontname=fontname, size=size)
    webbrowser.open(filename)

tags = get_tags(token)
draw_cloud(tags, 'wordcloud.png')
```