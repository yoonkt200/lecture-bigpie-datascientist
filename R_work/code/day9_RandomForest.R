# install.packages('randomForest')
library(randomForest)

library(mlbench)
data(Sonar)
Sonar[, 1:60] <- scale(Sonar[, 1:60])
ind = sample(1:nrow(Sonar),
             nrow(Sonar)*0.7,
             replace = F)
train = Sonar[ind, ]
test = Sonar[-ind, ]

r1 = randomForest(Class~., train)
r1$predicted
t1 = table(train$Class, r1$predicted)
diag(t1)
sum(diag(t1)) / sum(t1)

pred = predict(r1, newdata = test)
t2 = table(test$Class, pred)
diag(t2)
sum(diag(t2)) / sum(t2)

### mnist dataset에서 테스트
url = "https://github.com/ozt-ca/tjo.hatenablog.samples/raw/master/r_samples/public_lib/jp/mnist_reproduced"
# prac_test = read.csv(paste(url, "prac_test.csv", sep = "/"))
# prac_train = read.csv(paste(url, "prac_train.csv", sep = "/"))
short_prac_train = read.csv(paste(url, "short_prac_train.csv", sep = "/"))
short_prac_test = read.csv(paste(url, "short_prac_test.csv", sep = "/"))
str(short_prac_train)

# mnist randomforest 학습
train1 = short_prac_train
test1 = short_prac_test
train1$label = factor(short_prac_train$label)
test1$label = factor(short_prac_test$label)

r2 = randomForest(label~., train1)
pred2 = predict(r2, newdata = test1)
t2 = table(test1$label, pred2)
diag(t2)
sum(diag(t2)) / sum(t2)

# 픽셀을 0과 1로만 나누어서 학습
train2 = train1
train2[, -1] = round(train2[, -1]/255)
test2 = test1
test2[, -1] = round(test2[, -1]/255)

start1=Sys.time()
r3 = randomForest(label~., train2)
interval = Sys.time()-start1
pred3 = predict(r3, newdata = test2)
t3 = table(test1$label, pred3)
diag(t3)
sum(diag(t3)) / sum(t3)

# dna 데이터 연습
data("DNA")
View(DNA)
summary(DNA)

ind = sample(1:nrow(DNA)*0.7, nrow(DNA)*0.7, replace = F)
train_dna = DNA[ind,]
test_dna = DNA[-ind,]

start2=Sys.time()
r4 = randomForest(Class~., train_dna)
interval = Sys.time() - start2
pred4 = predict(r4, newdata = test_dna)
t4 = table(test_dna$Class, pred4)
diag(t4)
sum(diag(t4)) / sum(t4)

## 참고 : 이미지 처리
library()
im1 = as.matrix(train1[1, -1])
str(im1)
m1 = matrix(im1, , nrow = 28, byrow = T)
str(m1)
image(m1)