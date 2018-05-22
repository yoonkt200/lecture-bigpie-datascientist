# https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29
# data: https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data
setwd("C:/Users/ajou/Desktop/DataScience/R_work")
setwd("/Users/yoon/Documents/DataScience/R_work")
wbcd = read.csv("wisc_bc_data.csv", header = T, stringsAsFactors = F, sep = ",")
str(wbcd)
# --> 데이터의 단위, scale이 맞지 않음. 데이터를 표준화시켜줘야 함.

### 전처리 작업
wbcd <- wbcd[ , -1]
wbcd$diagnosis <- factor(wbcd$diagnosis)
levels(wbcd$diagnosis)

wbcd_n <- wbcd
wbcd_n[, -1] <- scale(wbcd[, -1]) # 데이터 표준화 작업

nn <- nrow(wbcd_n)
train = wbcd_n[1:(nn*0.7), ]
test = wbcd_n[((nn*0.7)+1):(nn+1), ]

### KNN
library(class)
pred1 = knn(train[,-1], test[,-1], train[,1], k=2) 

# 훈련데이터(레이블 X), 테스트(레이블 X), 트레인 레이블
# pred1 -> test값에 대한 예측값 리스트
t1 = table(test[,1], pred1)
cor1 = sum(diag(t1)/sum(t1))

### 최적의 k값을 찾아내기 위한 작업
out1 = data.frame()
for (i in 1:15){
  pred1 = knn(train[,-1], test[,-1], train[,1], k=i)
  t1 = table(test[,1], pred1)
  cor1 = sum(diag(t1)/sum(t1))
  out2 = cbind(i, cor1)
  out1 = rbind(out1, out2)
}
out1

out3 = which.max(out1[,2])
out1[out3,]