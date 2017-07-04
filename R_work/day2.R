setwd("C:/Users/ajou/Desktop/DataScience/R_work")
setwd("/Users/yoon/Documents/DataScience/R_work")

dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
library(KoNLP)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8")
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

# replace user dic : T는 추가, F는 대체
buildDictionary(user_dic = data.frame(c("빅데이터", "ncn")), replace_usr_dic = F)

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

txt_e = extractNoun(txt2)
txt_t = table(unlist(txt_e))
txt_s = sort(txt_t, decreasing = T)
txt_s1 = txt_s[str_length(names(txt_s)) > 1] # remove one character words

txt_h = head(txt_s1, 5)
barplot(txt_h)

pal1 = brewer.pal(7, "Set1")
wordcloud(names(txt_s1),  
          txt_s1, # data : must be table class
          scale=c(5, 0.5), # string size max, min
          min.freq = 2, # word freq min
          random.order = F, # location random
          rot.per = 0.2, # rotation percent
          family="AppleGothic")
