setwd("/Users/yoon/Documents/DataScience/R_work")

mobile <- read.csv('mobile2014.csv', stringsAsFactors = F)
dim(mobile)
names(mobile)

mobile[2,]
mobile[1035,]
table(mobile$Sentiment) # 긍정1, 부정0

### 문서-용어 만들기
library(tm)
corpus <- Corpus(VectorSource(mobile$Texts)) # 문서 만들기

stopwords() # 시스템 디폴트
stwds = stopwords("SMART") # 제거할 목록 명단 = 불용어 사전(너무 자주쓰여서 의미가 없는 단어들)
dtm <- DocumentTermMatrix(corpus,
                          control = list(tolower = T,
                                         removePunctuation = T,
                                         removeNumbers = T,
                                         stopwords = stwds,
                                         weighting = weightTfIdf))
inspect(dtm[1:20,])
str(dtm)
dtm
colnames(dtm)

### 회귀분석을 이용해 감정사전 만들기
# library(devtools)
# install_github("mannau/tm.plugin.sentiment")
library(tm.plugin.sentiment)
library(glmnet)
# glmnet 은 회귀분석에서 패널티 최대 우도 기법을 적용해서,
# 회귀분석에서 옳지 않은 요소에 벌점을 부과하는 방식으로,
# 선형 모델의 일반화를 학습시키는 방법을 지원하는 패키지이다.

X <- as.matrix(dtm)
Y <- mobile$Sentiment
res.lm <- glmnet(X, Y, family = "binomial", lambda = 0)
# glm이 일반적인 회귀를 한다면, glmnet은 패널티 최대 우도가 파라미터로 포함된 회귀이다.

##회귀분석 결과 회귀계수 정렬하기
coef.lm <- coef(res.lm)[ ,1] # 회귀계수만 저장
pos.lm <- coef.lm[coef.lm > 0] # 0보다 큰 계수만 저장
neg.lm <- coef.lm[coef.lm < 0] # 0보다 작은 계수만 저장
pos.lm <- sort(pos.lm, decreasing = T) #회귀계수 크기대로 정렬 후 저장 
neg.lm <- sort(neg.lm, decreasing = F) #회귀계수 크기대로 정렬 후 저장

length(pos.lm)
pos.lm

### 생성한 감정사전을 이용한 감정분석
# 감정 점수 계산 :: polarity = (p-n)/(p+n) -> (p=긍정단어 개수, n=부정단어 개수)
senti.lm <- polarity(dtm, names(pos.lm), names(neg.lm))

# 극(polarity) 감정 점수 0 or 1로 변환하기
senti.lm.b <- ifelse(senti.lm > 0, 1, 0)

# 정확도 평가 -> train, test를 나눠서 더 정확하게 해야함, 이건 임시 테스트
library(caret)
confusionMatrix(senti.lm.b, mobile$Sentiment)


### 추가 : 라쏘, 릿지, 엘라스틱넷으로 회귀 감정사전 만들기
########################################################################

set.seed(12345)
res.lasso <- cv.glmnet(X, Y, family = "binomial", alpha = 1,
                       nfolds = 4, type.measure = "class")
# 라쏘 회귀분석 결과 그래프
plot(res.lasso)
plot(res.lasso$glmnet.fit, xvar = "lambda")

# 라쏘 회귀분석 결과 회귀계수 정렬하기
options(scipen = 100) # 소수점 표현 방식 변경
coef.lasso <- coef(res.lasso, s = "lambda.min")[ ,1] # 최적 람다 값을 이용한 결과만
pos.lasso <- coef.lasso[coef.lasso > 0]
neg.lasso <- coef.lasso[coef.lasso < 0]
pos.lasso <- sort(pos.lasso, decreasing = T)
neg.lasso <- sort(neg.lasso, decreasing = F)

########################################################################

set.seed(12345)
res.ridge <- cv.glmnet(X, Y, family = "binomial", alpha = 0,
                       nfolds = 4, type.measure = "class")
##릿지 회귀분석 결과 그래프
plot(res.ridge)
plot(res.ridge$glmnet.fit, xvar = "lambda")

##릿지 회귀분석 결과 회귀계수 정렬하기
coef.ridge <- coef(res.ridge, s = "lambda.min")[,1] pos.ridge <- coef.ridge[coef.ridge > 0]
neg.ridge <- coef.ridge[coef.ridge < 0]
pos.ridge <- sort(pos.ridge, decreasing = T) neg.ridge <- sort(neg.ridge, decreasing = F)

########################################################################

set.seed(12345)
res.elastic <- cv.glmnet(X, Y, family = "binomial", alpha = .5,
                         nfolds = 4, type.measure="class")
##엘라스틱넷 회귀분석 결과 그래프
plot(res.elastic)
plot(res.elastic$glmnet.fit, xvar = "lambda")

##엘라스틱넷 회귀분석 결과 및 회귀계수 정렬하기
coef.elastic <- coef(res.elastic, s = "lambda.min")[,1] 
pos.elastic <- coef.elastic[coef.elastic > 0] 
neg.elastic <- coef.elastic[coef.elastic < 0] 
pos.elastic <- sort(pos.elastic, decreasing = T) 
neg.elastic <- sort(neg.elastic, decreasing = F)