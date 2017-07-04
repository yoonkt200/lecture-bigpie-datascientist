setwd("C:/Users/ajou/Desktop/DataScience/R_work")
setwd("/Users/yoon/Documents/DataScience/R_work")

library(KoNLP)
library(wordcloud)
library(stringi)
library(stringr)

txt = readLines('big.txt', encoding = "UTF-8")
length(txt) # vector data count
nrow(iris) # data frame count
length(iris) # data frame column count

### 텍스트마이닝 전처리 과정
# 사전 작업 (신조어 등록, 분야별 전문 용어 등)
# 텍스트 핸들링
# string to lower
# 유사 단어를 한 단어로 통일
# 불필요한 단어들 제거(특수문자 등)
# 공백 제거

# string to lower
str_to_lower(txt)

# replace user dic : T는 추가, F는 대체
buildDictionary(user_dic = data.frame(c("빅데이터", "ncn")), replace_usr_dic = F)