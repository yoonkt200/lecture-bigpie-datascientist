setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(mlbench)
data("Vowel")
nn = nrow(Vowel)
ind = sample(nn, nn*0.7, replace = F)
train = Vowel[ind, ]
test = Vowel[-ind, ]

library(C50); library(e1071); library(randomForest)

## decision tree
model1 = C5.0(x=train[, -11], y=train[, 11])

## naive bayes
model2 = naiveBayes(x=train[, -11], y=train[, 11])

## randomforest
model3 = randomForest(x=train[, -11], y=train[, 11])

pred1 = predict(model1, test)
pred2 = predict(model2, test)
pred3 = predict(model3, test)

t1 = table(test$Class, pred1)
t2 = table(test$Class, pred2)
t3 = table(test$Class, pred3)

correct1 = sum(diag(t1))/sum(t1)
correct2 = sum(diag(t2))/sum(t2)
correct3 = sum(diag(t3))/sum(t3)

# 가장 좋은 알고리즘 찾기
out1 = data.frame()
for (i in c(correct1, correct2, correct3)){
  out1 = rbind(out1, i)
}
colnames(out1) <- c("correct")
idx = which.max(out1$correct)
out1[idx,]
