setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(e1071)
library(mlbench)
data("Ozone")
View(Ozone)
O2 <- na.omit(Ozone)
O2$V1 <- as.numeric(O2$V1)
O2$V2 <- as.numeric(O2$V2)
O2$V3 <- as.numeric(O2$V3)

nn = nrow(O2)
train = O2[1:(nn*0.7), ]
test = O2[-(1:(nn*0.7)), ]

model1 = svm(V4~., train, cost=1000, gamma=1e-04)

# 에러 구하는 함수
rmse <- function(error) {
  sqrt(mean(error^2))
}

rmse(train$V4-model1$fitted) # cost, gamma 바꿔가며 테스트

pred1 <- predict(model1, newdata = test)
cbind(test$V4, pred1)
rmse(test$V4-pred1) # cost, gamma 바꿔가며 테스트

##################################################
##################################################
### 시계열 데이터 연습

data01 <- read.csv("날씨.csv", header = T)
data01 <- data01[ , -1]
str(data01)

data02 <- na.omit(data01)
data03 <- matrix(as.matrix(data02), nrow=1, byrow = F)

nn1 = length(data03)
dd1 = array(dim=c((nn1-6), 6))

for(i in 1:(nn1-6)){
  dd1[i,] = data03[i:(i+5)]
}
colnames(dd1) <- c("V1", "V2", "V3", "V4", "V5", "Y")

plot(1:length(data03), data03)

model2 = svm(x=dd1[, 1:5], y=dd1[, 6])
test_ind = sample(1:nrow(dd1), 10, replace = F)
pred2 = predict(model2, newdata = dd1[test_ind, 1:5])
cbind(dd1[test_ind, 6], pred2)
