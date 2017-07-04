# 2일차 


-----------------------


#### **1. 비정형 데이터 처리**

- R 패키지 참고 : http://r4pda.co.kr/

```

텍스트와 음성, 이미지는 비정형 데이터라고 할 수 있다. 최근 머신러닝 분야에서 가장 활발하게

연구 및 개발이 이루어지고 있는 것들이 바로 이 비정형 데이터라고 할 수 있다. 

비정형 데이터를 이용하여 인사이트를 도출하는 것이 데이터 분석 / 머신 러닝 분야의 가장 큰 화두인듯 하다.

```

> **1.1 텍스트 처리** : KoNLP를 이용하여

- 텍스트마이닝 전처리 과정

```

텍스트를 분석에 용이한 형태로 전처리 하기 위해서는, 가장 먼저 사전작업이 필요하다.

여기서 사전은 Dictionary를 의미한다. R Studio에서는 사전을 메모리상에 올린 뒤,

MergeUserDic(discrete 되었다.) 으로 사전을 구성한다. 

다음으로 텍스트를 pre-processing 해야하는데, 주로 소문자 변환, 유사단어 통일, 공백 제거 등의 과정이다.

```

```R

# string to lower
txt0 = str_to_lower(txt)

# word unite
txt1 = gsub("빅데이타", "빅데이터", txt0)
txt1 = gsub("bigdata", "빅데이터", txt1)
txt1 = gsub("big data", "빅데이터", txt1)
txt1 = gsub("[[:digit:]]", "", txt1)
txt1 = gsub("[[A-z]]", "", txt1)
txt1 = gsub("[[:punct:]]", "", txt1)
# txt1 = gsub("[a(\\d)+]", "", txt1) -> regular expression
txt1 = gsub("  ", " ", txt1)
txt2 = txt1[str_length(txt1)>1] # remove empty line

```

텍스트 전처리를 마쳤으면,

extractNoun (한글 형태소 분석의 경우)을 통해 간단한 텍스트 분석을 시행해보고

table을 이용해 결과를 확인해본다.

```R
txt_e = extractNoun(txt2)
txt_t = table(unlist(txt_e))
```

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
