setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)

cars

plot(cars)
model1 = lm(dist~speed, cars)
summary(model1)
write(model1$fitted.values, file='eff1.txt')
