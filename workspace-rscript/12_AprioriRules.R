setwd("/Users/yoon/Documents/DataScience/R_work")

### 트랜잭션 데이터 살펴보기
# install.packages("arules")
library(arules)
groceries <- read.transactions("groceries.csv",sep=",")
inspect(groceries[1:10])

itemFrequency(groceries[,1:3])
itemFrequencyPlot(groceries, support=0.1) 
# support : 아이템이 거래에서 차지하는 비율, 0.1이라면 즉 전체 거래에서 10%는 등장한다는 것.
itemFrequencyPlot(groceries, topN=20)
image(groceries[1:5])
image(sample(groceries, 100))

### 연관분석
library(arules)
groceryrules <- apriori(groceries, parameter=list(support=0.006, confidence=0.25,minlen=2))
summary(groceryrules)
inspect(groceryrules[1:5])
inspect(sort(groceryrules, by = "lift")[1:5])

### 특정 아이템 연관분석
berryrules <- subset(groceryrules, items %in% "berries")
inspect(berryrules)

berryrules <- subset(groceryrules, items %in% c("berries","yogurt"))
inspect(berryurles)