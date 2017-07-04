setwd("C:/Users/ajou/Desktop/DataScience/R_work")
setwd("/Users/yoon/Documents/DataScience/R_work")

# linux 명령어 기반, 워킹 메모리 변수 삭제
rm(list = ls())
# or rm(variable)

# 엔터를 기준으로 텍스트를 읽어주는 함수
# 이 파일의 맨 마지막에는 반드시 엔터가 있어야함 (\n)
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

### 텍스트마이닝 전처리 과정
# 사전 작업 (신조어 등록, 분야별 전문 용어 등)
# 텍스트 핸들링
# string to lower
# 유사 단어를 한 단어로 통일
# 불필요한 단어들 제거(특수문자 등)
# 공백 제거

#install.packages("KoNLP", dependencies = T) # dependencies : 연관 패키지 모듬 설치
#install.packages("rJava")

# Sys.setenv(JAVA_HOME = "/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home")
# Sys.getenv('JAVA_HOME')

dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
library(KoNLP)
library(stringi)
library(stringr)

Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌
useSejongDic() # 오래걸림

txt1 = gsub("bigdata", "빅데이터", txt0) # replace
txt1 = gsub('[A-z]', "", txt1) # 대괄호(패턴이라는 의미) 안에 : A부터 z까지를 없앰. 영어 제거
txt1 = gsub('[[:digit:]]', '', txt1) # 숫자 제거
txt1 = gsub('[[:punct:]]', '', txt1) # 그래픽 문자 제거
txt1 = gsub('  ', ' ', txt1) # 긴 공백 제거
# grap() : check

txt_n = extractNoun(txt1)
#str(txt_n)
txt_t = table(unlist(txt_n))
txt_t

#install.packages("wordcloud")
library(wordcloud)

wordcloud(names(txt_t), txt_t) # for window
wordcloud(names(txt_t), txt_t, family="AppleGothic") # fow mac
