# 4일차 


-----------------------


#### **1. 머신러닝과 감성분석**

피처 선택을 통해 데이터의 차원을 축소한 방법이 있었고,
이번에는 피처 추출을 통해 원래보다 낮은 차원의 새로운 부분공간으로 변환시켜 데이터를 요약하는
방법을 알아보겠다.

> **1.1 문서의 변수화 작업, bag-of-words**

```
감성분석은 문서의 양극성을 분석하는 작업이다. 
데이터에서 추출한 단어들을 설명 변수, 해당 데이터에 대한 양과 음의 레이블을 목적 변수로 하는 것이 일반적이다.

분류를 위한 설명 변수들을 정해줘야 하는데, 즉 텍스트를 수치형 피처 벡터로 표현할 수 있어야 한다. 
여기서는 이것을 백 오브 워드 모델의 개념을 활용하여 진행한다.

bag-of-words 모델은 전체 문서 집합의 단어들의 단어집을 만든 후, 특정 문서에서 단어집에 포함된 단어가
얼마나 자주 사용되었는지 횟수를 포함하는 각 문서에 대한 피처 벡터를 만든다.

각 문서의 단어들은 단어집 내에서의 부분집합을 나타낼 뿐이기 때문에, 피처벡터는 대부분 0이 된다.
문서에서 단어집에 있는 단어가 있을 확률이 당연히 높지 않기 때문에 그렇다.
이 때문에 보통 문서 용어 데이터를 희소하다(sparse)고 한다.
```

>> 파이썬 코드

```python
### bag-of-words는 CountVectorizer 클래스로 구현이 가능하다.
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer

count = CountVectorizer() 
# NLP 혹은 tokenizer 기능까지는 아니고, string에서 whitespace로 구분된 영역들을 벡터로 추출해줌.
docs = np.array([
        'The sun is shining',
        'The weather is sweet',
        'The sun is shining and the weather is sweet'])
bag = count.fit_transform(docs)

print(count.vocabulary_) # 단어집의 콘텐츠를 나타낸다. value값은 인덱스를 나타낸다.
print(bag.toarray()) # 단어집에 있는 단어들의 각각의 카운트 갯수를 나타낸다.
```

> **1.2 용어 빈도수-문서 빈도수(tf-idf)로 단어 관련성 평가**

```
문서의 텍스트를 처리할 때, 특정 단어가 여러 개의 문서에서 발생하는 경우를 자주 볼 수 있다.
많이 나온 단어일수록 중요하겠지만, 의미 없는 단어들이 많이 나올 수도 있을 것이다.

그래서 사용하는것이 바로 TF-IDF이다. 
TF-IDF는 해당 엔티티(단어)가 가지는 중요도를 알아내는 것이 목적이다.

TF(Term Frequency)는 특정 단어가 문서 내에서 얼마나 자주 등장하는지에 대한 것이고,
이 값이 높을수록 문서에서 중요한 것이라고 할 수 있다.
하지만 여러 문서들에서 공통적으로 등장한다면, 희소성이 없는 흔한 단어라는 것을 나타낸다.
이것을 DF(Document Frequency)라 하며, DF는 특정 단어가 문서군 내에서 얼마나 등장하는
지에 대한 것이다. IDF는 DF의 역수인데, 전체 문서 갯수를 해당 단어가 등장한 갯수로 나누는 것이다.
TF-IDF는 이 두 값을 곱한 값이다.

수식에 대한 직관으로 풀어서 설명하자면, 
한 문서 내에서 등장하는 여부에 전체 문서에서 희소하게 등장하는 여부를 곱한 것이다.
당연히 TF-IDF 값이 높으면 유니크한 엔티티일 것이다.

TF-IDF를 구현할 때, IDF의 값 등이 역수를 취하다 보니 무한히 커질 수가 있다.
이를 방지하기 위해 표준화를 시켜줘야 하는데, 보통 log를 씌우거나 하는 등으로 진행된다.
또한 DF의 역수를 취할 때 분모가 0이 되지 않도록 1을 더해주는 방법을 취해야 한다.
파이썬에서는 sklearn에서 TfidfTranformer라는 클래스로 구현되어있다.

문서의 길이가 길어질수록 빈도가 높아지는 경향이 있기 때문에, 
raw-term frequency를 정규화하는 과정이 필요하다.
TfidfTranformer에서는 raw-term frequency를 정규화하는 과정이 디폴트로 내장되어있는데,
L2 정규화를 적용한다.
```

```python
### tf-idf
np.set_printoptions(precision=2)
from sklearn.feature_extraction.text import TfidfTransformer

tfidf = TfidfTransformer(use_idf=True, norm='l2', smooth_idf=True)
print(tfidf.fit_transform(count.fit_transform(docs)).toarray())
# tf-idf를 계산한 행렬을 나타낸다.
```