setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

sms_raw_data = read.csv("sms_spam.csv", header = T, fileEncoding="UTF-8")
str(sms_raw_data)

### 분류하기 이전에 데이터 드리블
# 항상 factor check를 해줘야함. droplevel을 쓰는거랑 같은 개념.
sms_raw_data$type <- factor(sms_raw_data$type)
library(stringr)
sms_raw_data$text <- str_to_lower(sms_raw_data$text)

# 말뭉치 드리블
library(tm)
table(sms_raw_data$type)
sms_corpus <- Corpus(VectorSource(sms_raw_data$text))
print(sms_corpus)
inspect(sms_corpus[1:20])

corpus_clean <- tm_map(sms_corpus, tolower)
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stripWhitespace)
inspect(corpus_clean[1:20])

# 문서-용어 희소 매트릭스 생성
sms_dtm <- DocumentTermMatrix(corpus_clean)
inspect(sms_dtm)

# 데이터셋 생성
sms_data_train <- sms_raw_data[1:4169, ]
sms_data_test <- sms_raw_data[4170:5559, ]

sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test <- sms_dtm[4170:5559, ]

sms_corpus_train <- corpus_clean[1:4169]
sms_corpus_test <- corpus_clean[4170:5559]

# 스팸 비율 확인
prop.table(table(sms_data_train$type))
prop.table(table(sms_data_test$type))

# 데이터를 스팸과 햄으로 분리
spam <- subset(sms_data_train, type="spam")
ham <- subset(sms_data_test, type="ham")

# 간단한 시각화
library(wordcloud)
wordcloud(sms_corpus_train, min.freq = 30, random.order = F)

wordcloud(spam$text, min.freq = 40, scale = c(3, 0.5))
wordcloud(ham$text, min.freq = 40, scale = c(3, 0.5))

# 빈번한 단어와 관련된 지시자
sms_dict <- findFreqTerms(sms_dtm_train, 5) 
sms_train <- DocumentTermMatrix(sms_corpus_train, list(dictionary = sms_dict)) 
sms_test <- DocumentTermMatrix(sms_corpus_test, list(dictionary = sms_dict))

convert_count <- function(x) {
  x <- ifelse(x>0, 1, 0)
  x <- factor(x, levels = c(0,1),
              labels = c("No", "Yes"))
}

sms_train <- apply(sms_train,
                   MARGIN = 2,
                   convert_count)
sms_test <- apply(sms_test,
                   MARGIN = 2,
                   convert_count)

# 모델 학습
library(e1071)
start_time = Sys.time()
sms_classifier <- naiveBayes(sms_train, sms_data_train$type) 
delay = Sys.time() - start_time

sms_classifier$apriori

# 평가
sms_test_pred <- predict(sms_classifier, sms_test)
library(gmodels)
CrossTable(sms_test_pred, sms_data_test$type, 
           prop.chisq = FALSE, prop.t = FALSE, prop.r = FALSE,
           dnn = c('predicted', 'actual'))

# 아이리스 적용
ind = sample(1:nrow(iris),
             nrow(iris)*0.7,
             replace = F)
train = iris[ind, ]
test = iris[-ind, ]

iris_classifier = naiveBayes(Species~., data=train)
pred_iris = predict(iris_classifier, test)
table(test$Species, pred_iris)
