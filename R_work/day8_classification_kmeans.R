setwd("/Users/yoon/Documents/DataScience/R_work")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

a <- c(1,6)
b <- c(2,4)
c <- c(5,7)
d <- c(3,5)
e <- c(5,2)
f <- c(5,1)

### 계층적 클러스터링
c_data <- data.frame(a,b,c,d,e,f)
c_data <- t(c_data) # col, row trans
d <- dist(c_data, method = 'euclidean') 
# dist: 행들 사이의 유클리드 거리를 계산해줌.
# 열의 요소는 계산으로만 씀.
h1 <- hclust(d, method = 'single')
plot(h1)

### Kmeans
k1 = kmeans(iris[, 1:4], 3, iter.max = 100) 
# iter.max 값은 평균을 업데이트하는 작업을 몇번 반복하는지에 관한 것
k1$cluster
k1$withinss # -> 그룹 내의 오차값의 합
k1$tot.withinss

table(iris$Species, k1$cluster)

k0 = data.frame()
for (i in 1:6){
  k2 = kmeans(iris[, 1:4], i, iter.max = 100)
  k3 = cbind(i, k2$tot.withinss)
  k0 = rbind(k0, k3)
}
plot(k0, type = 'b')
k0[which.min(k0[,2]), ]
