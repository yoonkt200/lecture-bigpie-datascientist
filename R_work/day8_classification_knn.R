# https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29
# data: https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data
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

# 훈련데이터(레이블 X), 테스트(레이블 X), 트레인 레이블, k개수(-> k-1개의 그룹으로 예측?)
# pred1 -> test값에 대한 예측값 리스트
t1 = table(test[,1], pred1)
cor1 = sum(diag(t1)/sum(t1))

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
## Q: 레이블이 n개일때 k값이 n개가 아닌데 더 정확한 이유
## 만약 레이블이 B, M둘이어도, 나뉘어진 그룹이 10,20,30,40대라고 하면
## 어떤 특정한 그룹에서 B, M이 들어맞을 확률이 높아져서 그렇다고 생각하면 됨.
## 즉, 실제 레이블 수와 K 그룹 수를 맞춰줄 필요는 없음.