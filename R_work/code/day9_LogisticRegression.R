data1 = iris[1:100, ]

levels(data1$Species)
table(data1$Species)
# 원 데이터에 3개의 factor가 있는데, 해당 factor 데이터가 모두 없어져도
# factor 요소로는 남음.

data1$Species=factor(data1$Species)
# 다시 factor를 해주면 없는 요소는 없어짐.
# 없는 factor때문에 에러가 발생하는 상황이 많으므로 항상 해주는게 좋음.


### 로지스틱 회귀
m <- glm(Species~., data = data1, family = "binomial") 
# binomial 은, glm이 제공하는 회귀모델중 로지스틱이라는 것.
m$fitted.values

# 데이터셋 나눠서 로지스틱 회귀
set.seed(1000)
ind = sample(1:nrow(data1),
             nrow(data1)*0.7,
             replace = F)
train = data1[ind, ]
test = data1[-ind, ]
m <- glm(Species~., data = train, family = "binomial")
m$fitted.values
train_y = ifelse(m$fitted.values>=0.5, 2, 1)
table(train_y)
table(train$Species, train_y)

pred1 = predict(m, newdata = test, type = 'response') 
# response는 0~1사이의 결과값을 구해준다.
pred_label = ifelse(pred1 >= 0.5, 2, 1)
table(test$Species, pred_label)

test$label = pred_label
View(test)

### 다항 로지스틱 회귀
set.seed(1000)
ind = sample(1:nrow(iris),
             nrow(iris)*0.7,
             replace = F)
train = iris[ind, ]
test = iris[-ind, ]
library(nnet)
(m <- multinom(Species~., data=train)) # 다항회귀는 nnet의 multinom을 사용.
m$fitted.values
m_class <- max.col(m$fitted.values)

table(m_class)
table(train$Species, m_class)

pred3 = predict(m, newdata = test, type = 'class')
# class는 factor 결과값을 구해준다.
table(pred3)
table(test$Species, pred3)

### 적용
library(mlbench)
data(Sonar)
Sonar[, 1:60] <- scale(Sonar[, 1:60])
ind = sample(1:nrow(Sonar),
             nrow(Sonar)*0.7,
             replace = F)
train = Sonar[ind, ]
test = Sonar[-ind, ]
model <- glm(Class~., data = train, family = "binomial")
pred4 = predict(model, newdata = test, type = 'response') 
pred_label = ifelse(pred4 >= 0.5, 2, 1)
t1 = table(test$Class, pred_label)
test$pred <- pred_label

diag(t1) # table의 대각선 값을 추출하는 함수
sum(diag(t1)) / sum(t1) # 전체 중에 잘 맞힌것만 찾아낸 비율
