# 3일차 


-----------------------


#### **1. 데이터 조작**


> **1.1 데이터 생성 및 저장**

```R

setwd("/Users/yoon/Documents/DataScience/R_work") # write data file
write.xlsx(iris, 'iris.csv')

methods(plot) # check methods

a1 = iris
a2 = cars

save(a1, a2, file = 'a.rdata') # rdata save and load
load('a.rdata')

```

> **1.2 데이터 manipulation**

```R

x1 = matrix(1:15, nrow=5)
x2 = matrix(1:15, nrow=5, byrow = T)

rbind(x1,x2) # bind row data

x3 = c(1,3) # concatenate vector data
for(i in 1:10){
  x3 = c(x3, i)
}

x4 = c(1,2,3)
x5 = c(5,6,7)

cbind(x4, x5)
rbind(x4, x5)

### merge example1
xx <- data.frame(name=c("a", "b", "c", "d"), math=c(1,2,3,4))
yy <- data.frame(name=c("c", "b", "a"), english=c(4,5,6))
merge(xx, yy) # x에는 있는데 y에는 없는거 제외하고 merge.

### merge example2
xx <- data.frame(name1=c("a", "b", "c", "d"), math=c(1,2,3,4))
yy <- data.frame(name2=c("c", "b", "a"), english=c(4,5,6))
merge(xx, yy)
merge(xx, yy, all=T, by.x='name1', by.y='name2')

# subset & set factor
s1 = subset(iris, Species == "setosa")
str(s1)
str(iris)
s1$Species = factor(s1$Species)
str(s1)

```

-----------------------


#### **2. 베이즈 정리**

```


```

-----------------------
