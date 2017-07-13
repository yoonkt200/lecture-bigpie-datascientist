# install.packages("party")
library(party)

set.seed(1000)
ind = sample(1:nrow(iris),
             nrow(iris)*0.7,
             replace = F)
train = iris[ind, ]
test = iris[-ind, ]

c1 = ctree(Species~., train)
plot(c1)

ctl <- ctree_control(maxdepth=2)
c1 = ctree(Species~., train, controls = ctl)
plot(c1)

pred = predict(c1, newdata=test)
sum(pred==test$Species)/nrow(test)
# p value는 분리 기준이 타당한가에 대한 검정 

### 적용
data("Vowel")
set.seed(100)
ind2 = sample(1:nrow(Vowel),
              nrow(Vowel)*0.7,
              replace = F)
train = Vowel[ind2, -1]
test = Vowel[-ind2, -1]
c2 = ctree(Class~., train)
pred2 = predict(c2, newdata=test)
table(test$Class, pred2)
sum(test$Class==pred2)/nrow(test)
# tree depth는 3~4를 벗어나면 성능이 떨어질 수 있음.

### pruning
install.packages("tree")
library(tree)
library(MASS)

ir.tr = tree(Class~., train) # 가지치기 전
plot(ir.tr)
text(ir.tr, all = T)

plot(prune.misclass(ir.tr)) 
# 트리의 depth가 적당하면서 misclass가 낮은 지점은 10~15 사이.

ir.tr1 = prune.misclass(ir.tr, best=14) # 가지치기 후
plot(ir.tr1)
text(ir.tr1, all = T)

