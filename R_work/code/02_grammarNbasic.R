setwd("/Users/yoon/Documents/DataScience/R_work")

if (TRUE){
  print("hello true")
} else{
  print("hello false")
}

x=5
x %in% c(1,4,7,5) # search

sum = 0
for(i in seq(1, 100, 3)){ # using seq
  sum = sum + i
  print(sum)
}

seq(1, 100, 3) # interval sequential number

s = array(dim=c(1,120)) # set dimension of array
# s = array(c(1,50)) # example for difference

for (i in 1:120){
  if(iris[i, 1]> 7 ){
    s[1,i] = 1
  } else{
    s[1,i] = 0 
  }
}
s
s1 = ifelse(iris$Sepal.Length > 7, 1, 0) # same with above

ind1 = sample(1:150, 10, replace = T) # sampling

m2 = c() # empty vector
for (i in 1:100){
  ind1 = sample(1:150, 10, replace = T)
  m1 = mean(ind1)
  m2 = c(m2, m1) # vector chain assign process
}

hist(m2)
mean(m2)

add <- function(a, b){
  add1 = a+b
  return (add1)
}

add(1,3)

add2 <- function(a, b){
  if(is.numeric(a) == T){
    add = a+b
    return(add)
  } else{
    add = paste(a, b, sep = '-') # paste string
    return(add)
  }
}

add2("a", 5)

c(T, T, T) & c(T, F, T) # check '==' for vector

5%/%3
1:(2*pi)
x = seq(0, 2*pi, 0.01)
y = sin(x) + rnorm(length(x))
plot(x,y)

data1 = read.table('clipboard', header = T) # for window
data1 = read.table(pipe("pbpaste"), header = T) # for mac

data2 = read.csv("data1.csv")

str(data2)
names(data2) = c("x1", "x2") # set column names

# string + num 자동화 생성 -> 변수이름에 유용
paste("TEST", 1:10)

# install.packages("xlsx")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
library(xlsx)

data3 = read.xlsx("data1.xlsx", sheetIndex = 1, header = T)