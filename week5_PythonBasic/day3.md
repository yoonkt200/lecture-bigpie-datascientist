# 3일차 


-----------------------


#### **1. pandas를 이용한 데이터 전처리**


> **1.1 DataFrame형태의 데이터 조작**

```python
### 기본적인 json read
import json
path = '/Users/yoon/Downloads/pydata/pydata-book-master/'
path = path + 'ch02/usagov_bitly_data2012-03-16-1331923249.txt'

records = [json.loads(line) for line in open(path, encoding="utf-8")]
records[0]['tz']
records[0]
records['tz'] # -> error! 이런 문제점을 해결하기 위해 df 구조가 필요한 것.


### pandas로 read
data1 = pd.read_json(path, lines=True, encoding="utf-8")
type(data1)
data1.loc
data1.index
data1.columns
data1['tz']


### 행렬 단위로 접근
data1[0:2]
data1.loc[0:2] # loc == ix, ix는 decreated
data1.loc[0]
data1.loc[0, 'tz']


### pandas로 DataFrame 형태로 변환
from pandas import DataFrame, Series
df1 = DataFrame(records)
df1.loc[0:3, 'al'] # -> error : loc은 label을 통해 값을 찾을 수 있다.
df1.ix[0:3, 2] # ix는 integer position과 label 모두 사용 가능하다.
df1.iloc[0:4, 2]
# loc + iloc = ix


### NA처리와 df의 장점 비교
time_zones = [rec['tz'] for rec in records if 'tz' in rec]
# if 'tz' in rec 부분을 추가해야 NA 데이터를 처리함. 추가 안하면 NA 처리 못해서 에러.
time_zones1 = df1['tz']
time_zones1 = time_zones1.dropna()
# 같은 기능을 쉽게 수행
len(time_zones)


### 파이썬 자료구조로 활용 -> 패키지가 없을 때
def get_counts(sequence):
    counts={} # empty dict
    for x in sequence:
        if x in counts:
            counts[x] += 1
        else:
            counts[x] = 1
    return counts

counts = get_counts(time_zones)
counts
type(counts)
counts['America/New_York']


### 기본 패키지 사용했을 때 -> 디폴트로 value가 넣어져있는 형태의 dict
from collections import defaultdict
def get_counts2(sequence):
    counts = defaultdict(int)
    for x in sequence:
        counts[x] += 1
    return counts

counts1 = get_counts2(time_zones)
counts1
type(counts1)
counts['America/New_York']


### 상위 데이터 추출
def top_counts(count_dict, n=10):
    value_key_pairs = [(count, tz) for tz, count in count_dict.items()]
    value_key_pairs.sort()
    return value_key_pairs[-n:]

top10 = top_counts(counts, n=10)
type(top10)
type(top10[0])
top10

# dict는 순서가 없는 자료형이기 때문에, 기본적으로 sort가 되지 않기 때문에 위의 과정을 거침.
# operator를 이용하면 쉽게 sort가 가능.
import operator
sorted_counts = sorted(counts.items(), key=operator.itemgetter(1))[-10:]


### Counter 함수로 매우 쉽게 가능
from collections import Counter
counts2 = Counter(time_zones)
counts2
type(counts2)
counts2.most_common(10)
```

> **1.2 pd의 전처리 관련 여러 기능**

```
```# -*- coding: utf-8 -*-

import json
path = '/Users/yoon/Downloads/pydata/pydata-book-master/'
path_records = path + 'ch02/usagov_bitly_data2012-03-16-1331923249.txt'
records = [json.loads(line) for line in open(path_records, encoding="utf-8")]

from pandas import DataFrame, Series
import pandas as pd
import numpy as np

frame = DataFrame(records)
type(frame)

### 기본 접근
frame.ix[2,:]
frame.iloc[2,:]
frame['tz'][:10]

###############################################################################
###############################################################################

### dataframe의 멤버 함수들 : count
tz_counts = frame['tz'].value_counts()
type(tz_counts)
tz_counts[0]
tz_counts[:10]
tz_counts['America/New_York']

###############################################################################
###############################################################################

### 결측데이터, NaN데이터 처리
clean_tz = frame['tz'].fillna("Missing") # NaN을 처리해줌
clean_tz[clean_tz=='']='Unknown' # str type이지만, 없는 데이터를 처리해줌
frame['tz'][7]
type(frame['tz'][7])
frame['tz'][13]
type(frame['tz'][13])

tz_counts1 = clean_tz.value_counts()
tz_counts1[:10]

###############################################################################
###############################################################################

### IDE에서 그래프 콘솔로 보기
import matplotlib
# %matplotlib inline 
# console에서 그래프를 볼 수 있게 해줌.

tz_counts1[:10].plot(kind='barh', rot=0)

###############################################################################
###############################################################################

### 다양한 데이터 형식 읽고 합치기
unames = ['user_id', 'gender', 'age', 'occupation', 'zip']
users = pd.read_table(path + 'ch02/movielens/users.dat', 
                      sep='::', header=None, names=unames, engine='python')
users.plot('zip')

rnames = ['user_id', 'movie_id', 'rating', 'timestamp']
ratings = pd.read_table(path + 'ch02/movielens/ratings.dat', 
                      sep='::', header=None, names=rnames, engine='python')


mnames = ['movie_id', 'title', 'genres']
movies = pd.read_table(path + 'ch02/movielens/movies.dat', 
                      sep='::', header=None, names=mnames, engine='python')

data = pd.merge(pd.merge(ratings, users), movies)

###############################################################################
###############################################################################

### 데이터 드리블
mean_ratings = data.pivot_table('rating', index='title', 
                                columns='gender', aggfunc='mean')
mean_ratings[:5]

ratings_by_title = data.groupby('title').size()
ratings_by_title[:10]

# 참고 :: active_titles = ratings_by_title[ratings_by_title >= 250] 
# 이건 데이터 자체를 리턴
active_titles_index = ratings_by_title.index[ratings_by_title >= 250] 
# 250명 이상이 참여한 데이터의 인덱스 추출

mean_ratings2 = mean_ratings.loc[active_titles_index] 
# 250명 이상이 참여한 영화의 남녀 평균평점 데이터

top_female_ratings = mean_ratings2.sort_values(by='F', ascending=False)
top_female_ratings[:5] # 여성이 좋아하는 순위

top_male_ratings = mean_ratings2.sort_values(by='M', ascending=False)
top_male_ratings[:5] # 남성이 좋아하는 순위

mean_ratings2['diff'] = mean_ratings2['M'] - mean_ratings2['F'] # 남녀차이
sorted_by_diff = mean_ratings2.sort_values(by='diff')
sorted_by_diff[:5]
sorted_by_diff[::-1][:15] # ::-1 은 뒤집기 한거임

###############################################################################
###############################################################################

### 남녀 상관없이, 영화에 대한 호불호가 극명한 영화
# -> 분산이나 표준편차로 판단
rating_std_by_title = data.groupby('title')['rating'].std()
rating_std_by_title2 = rating_std_by_title[active_titles_index] # 250이상으로 필터링

# 정렬
import operator
rating_std_by_title2 = sorted(rating_std_by_title2.items(), 
                              key=operator.itemgetter(0))[-10:]
