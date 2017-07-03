setwd("C:/Users/ajou/Desktop/DataScience/R_work")

# linux 명령어 기반, 워킹 메모리 변수 삭제
rm(list = ls())
# or rm(variable)

# 엔터를 기준으로 텍스트를 읽어주는 함수
txt = readLines('big.txt',
          encoding = 'UTF-8')
str(txt)
txt[10]

#### list structure
list1 = list(sp=1, sp2=c(1,3,5), y=c("A", "B"))

list1[2] # 통째로 가져옴
list1$sp2 # 값만 가져옴
list1[[2]] # 값만 가져옴

list2 = list(x=list1, y=list1)
str(list2)
list2[1]
list2[[1]]
list2[[1]][[2]]

#### 공백열 제거하는 전처리
nchar(txt)
txt0 = txt[nchar(txt)>1]

#### 텍스트마이닝
install.packages("KoNLP", dependencies = T) # dependencies : 연관 패키지 모듬 설치
library(KoNLP)

# useSejongDic()

txt1 = gsub("bigdata", "빅데이터", txt0) # replace
txt1 = gsub('[A-z]', "", txt1) # 대괄호(패턴이라는 의미) 안에 : A부터 z까지를 없앰. 영어 제거
txt1 = gsub('[[:digit:]]', '', txt1) # 숫자 제거
txt1 = gsub('[[:punct:]]', '', txt1) # 그래픽 문자 제거
txt1 = gsub('  ', ' ', txt1) # 긴 공백 제거
# grap() : check

txt_n = extractNoun(txt1)
#str(txt_n)
txt_t = table(unlist(txt_n))

install.packages("wordcloud")
library(wordcloud)

wordcloud(names(txt_t), txt_t)
