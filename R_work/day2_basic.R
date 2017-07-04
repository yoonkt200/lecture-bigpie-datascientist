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
