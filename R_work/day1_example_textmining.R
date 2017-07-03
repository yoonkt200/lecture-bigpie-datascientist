setwd("C:/Users/ajou/Desktop/DataScience/R_work")

# linux 명령어 기반, 워킹 메모리 변수 삭제
rm(list = ls())
# or rm(variable)

# 엔터를 기준으로 텍스트를 읽어주는 함수
txt = readLines('big.txt',
          encoding = 'UTF-8')
str(txt)
txt[10]

# list structure
list1 = list(sp=1, sp2=c(1,3,5), y=c("A", "B"))

list1[2] # 통째로 가져옴
list1$sp2 # 값만 가져옴
list1[[2]] # 값만 가져옴

list2 = list(x=list1, y=list1)
str(list2)
list2[1]
list2[[1]]
list2[[1]][[2]]

# 공백열 제거하는 전처리
nchar(txt)
txt0 = txt[nchar(txt)>1]
txt0

# 텍스트마이닝
install.packages("KoNLP", dependencies = T) # dependencies : 연관 패키지 모듬 설치
library(KoNLP)

extractNoun