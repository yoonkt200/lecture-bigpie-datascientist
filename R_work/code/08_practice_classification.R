setwd("C:/Users/ajou/Desktop/DataScience/R_work")
setwd("/Users/yoon/Documents/DataScience/R_work")
teens = read.csv("snsdata.csv", header = T, stringsAsFactors = F, sep = ",")

table(teens$gender, useNA = "ifany")
summary(teens$age)
teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA)
# age에서 outlier 제거

teens$female <- ifelse(teens$gender == 'F', 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)

ave_age <- ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm = T))
# ave 함수는 aggregate와 비슷하지만, 벡터형태로 배출한다는 게 다른점.
teens$age <- ifelse(is.na(teens$age), ave_age, teens$age)
# 나이가 비어있다면, 졸업년도의 평균 나이로 채워줌.
table(teens$age, useNA = "ifany")
length(which(teens$age == NA))
# 나이가 NA 없이 다 채워졌다는 것을 확인.

interests <- teens[, 5:40]
interests_z <- scale(interests)

teens_cluster <- kmeans(interests_z, 5)
table(teens_cluster$cluster)
teens_cluster$centers

teens$cluster <- teens_cluster$cluster
aggregate(data=teens, age ~ cluster, mean)
