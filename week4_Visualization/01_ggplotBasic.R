setwd("/Users/yoon/Documents/DataScience/week4_Visualization")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(ggplot2)
qplot(Sepal.Length, Petal.Length, data=iris) # design good!
plot(iris$Sepal.Length, iris$Petal.Length) # shit!

qplot(Sepal.Length, Petal.Length, data=iris, color = Species, size = Petal.Width)
qplot(Sepal.Length, Petal.Length, data=iris, color = Species, geom="line")
qplot(age, circumference, data=Orange, color = Tree, geom="line", 
      main = "How does orange tree circumference vary with age?")
