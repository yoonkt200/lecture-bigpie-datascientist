setwd("/Users/yoon/Documents/DataScience/R_work") 
library(arules)

## ø¨∞¸±‘ƒ¢ √£±‚

groceries <- read.transactions("groceries.csv", sep = ",")
summary(groceries)
inspect(groceries[1:5])

itemFrequencyPlot(groceries, support=0.1) # 10% ¡ˆ¡ˆµµ ¿ÃªÛ ¡¶«∞. º≠∆˜∆Æ¥¬ Ω«¿¸ ¿˚øÎ¿« ¿«πÃ∞° ≈≠
itemFrequencyPlot(groceries, topN=20)

## apriori «‘ºˆ

myrules = apriori(data=groceries, parameter = list(support = 0.006, confidence = 0.25, minlen=2))
summary(myrules)

inspect(myrules[1:3]) # »≠∫– Ωƒπ∞¿ª ªÁ∏È ¿¸¿Ø∏¶ ªÍ¥Ÿ. 
#¿¸√º ∞≈∑°¡ﬂø° µ—¿ª ∞∞¿Ã ªÍ ∫Ò¿≤¿∫ 69%, 
#»≠∫– Ωƒπ∞¿ª ªÍ ªÁ∂˜ ¡ﬂ 40%∞° ¿¸¿Ø∏¶ ∞∞¿Ã ªÍ¥Ÿ.
#±◊≥… ¿¸¿Ø∏¶ ªÍ ªÁ∂˜∞˙ ø¨∞¸±‘ƒ¢ø° ¿««ÿº≠ ªÍ ªÁ∂˜¿« ∫Ò¿≤

inspect(sort(myrules, by = "lift")[1:5])
berryrules <- subset(myrules, items %in% "berries") #µ˛±‚∏∏ ∞Àªˆ
inspect(berryrules)

write(myrules, file = "groceryrules1.csv", sep = ",", quote = TRUE, row.names = FALSE)
myrules_df<-as(myrules, "data.frame")
str(myrules_df)

##############################################################################################

## ±∫¡˝ ∫–ºÆ

teens <- read.csv("snsdata.csv")
str(teens)

# ∞·√¯ µ•¿Ã≈Õ »Æ¿Œ
table(teens$gender)
table(teens$gender, useNA = "ifany")
summary(teens$age)

teens$age <- ifelse(teens$age >= 13&teens$age <20, teens$age, NA)
summary(teens$age)

# ∞·√¯∞™ πÆ¡¶ «ÿ∞·, 1. ªË¡¶, 2. π¸¡÷«¸ µ•¿Ã≈Õ-¥ıπÃƒ⁄µ˘
# ∞·√¯ µ•¿Ã≈Õ∞° ¿˚¿ª ∂ß¥¬ ≥Ø∑¡µµ µ«¡ˆ∏∏, ≈¨ ∂ß¥¬ ≥Ø∏Æ∏È ∞¸∞Ë∏¶ æÀ ºˆ æ¯∞‘ µ…ºˆµµ ¿÷¥Ÿ.
teens$female <- ifelse(teens$gender == "F"&!is.na(teens$gender), 1,0)
teens$no_gender <- ifelse(is.na(teens$gender), 1,0)

# 3. ø¨º”«¸ º˝¿⁄µ•¿Ã≈Õ : ªı∑ŒøÓ ∞™¿∏∑Œ ¥Î√º
mean(teens$age) # doesn't work
mean(teens$age, na.rm =TRUE)
aggregate(data = teens, age~gradyear, mean, na.rm=TRUE)

ave_age<-ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm = TRUE))
teens$age<-ifelse(is.na(teens$age), ave_age, teens$age)

# ∫Øºˆ∞° ∞·√¯∞™¿œ ∂ß, µ•¿Ã≈Õ∏¶ ≥Ø∏Æ±‚ æ∆±ÓøÔ ∂ß¥¬, ¥Ÿ∏• æ÷µÈ¿« ∆Ú±’¿ª ≥÷æÓ¡÷¥¬ πÊπ˝ µÓ¿∏∑Œ «ÿπˆ∏± ºˆµµ ¿÷¥Ÿ.
# µ•¿Ã≈Õ ∏∂¿Ã¥◊¿∫ recall, precision ∞™¿Ã ¡¡¿∏∏È ∞˙¡§¿Ã ±∏∑¡µµ ∏∏ªÁ ok
# µ•¿Ã≈Õ∞° 500∞≥ ¿÷¥Ÿ∏È, 6:4 ¡§µµ∑Œ ≥™¥©¥¬∞‘ ¿˚¥Á.

interests <- teens[5:40]
interests_z <- as.data.frame(lapply(interests, scale))

library(stats)
teen_clusters<-kmeans(interests_z, 5)
teen_clusters$size
teen_clusters$centers

teens$cluster <-teen_clusters$cluster
teens[1:5, c("cluster", "gender", "age", "friends")]
aggregate(data = teens, age ~ cluster, mean)
aggregate(data = teens, female ~ cluster, mean)
aggregate(data = teens, friends ~ cluster, mean)

#########################################################################

## ∞Ë√˛¿˚ ±∫¡˝»≠
library(ISLR)

class(NCI60);str(NCI60) # «— ∂Û¿Œø°º≠ µŒ∞≥ «œ¥¬∞≈¿”.
nci.labs = NCI60$labs
nci.data = NCI60$data

dim(nci.data)

# æœ ¿Ø«¸ ¡∂ªÁ
table(nci.labs)

# µ•¿Ã≈Õ ¡§±‘»≠
sd.data = scale(nci.data)

# ∞≈∏Æ «‡∑ƒ
data.dist=dist(sd.data)

# ∞Ë√˛¿˚ ±∫¡˝
hclust(data.dist, method="complete")

par(mfrow=c(1,3))
plot(hclust(data.dist), labels = nci.labs)
plot(hclust(data.dist, method="average"),labels=nci.labs)
plot(hclust(data.dist, method="single"),labels=nci.labs)

## 4∞≥¿« ≈¨∑ØΩ∫≈Õ ª˝º∫
hc.out = hclust(dist(sd.data))
hc.clusters = cutree(hc.out,4)
table(hc.clusters, nci.labs)

par(mfrow=c(1,1))
plot(hc.out, labels=nci.labs)
abline(h=139, col="red")

table(hc.clusters)