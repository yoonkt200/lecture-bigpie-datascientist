setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

credit = read.csv("credit.csv", header = T, fileEncoding="UTF-8")
str(credit)
ind = order(runif(1000))
train = credit[ind[1:900], ]
test = credit[ind[901:1000], ]

# decision tree
library(C50)
model1 = C5.0(default~., train)
model1 = C5.0(x=train[, -17], y=train[,17])
model2 = C5.0(x=train[, c(1,2,5,6)], y=train$default)

pred1 = predict(model1, test)
table(test$default, pred1)

pred2 = predict(model2, test)
table(test$default, pred2)

# naive bayes
library(e1071)
model3 = naiveBayes(default~., train)
pred3 = predict(model3, test)
table(test$default, pred3)

# randomForest
library(randomForest)
model4 = randomForest(default~., train)
pred4 = predict(model4, test)
table(test$default, pred4)