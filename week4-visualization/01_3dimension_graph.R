setwd("/Users/yoon/Documents/DataScience/week4_Visualization")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

### 3차원 데이터의 관계성을 보여줌 - 1
xx <- c(1,2,3,4,5)
yy <- c(2,3,4,5,6)
zz <- c(10,5,100,20,10)
symbols(xx, yy, zz)

### 3차원 데이터의 관계성을 보여줌 - 2
c <- matrix(c(xx,yy,zz), 5,3)
pairs(c)

### 3차원 데이터의 관계성을 보여줌 - 3
x1 = seq(-3, 3, length = 50)
x2 = seq(-4, 4, length = 60)
f <- function(x1, x2){
  x1^2 + x2^2 + x1*x2
}
y <- outer(x1,x2,FUN=f)
contour(x1,x2,y)

### 3차원 그래프
x1 = seq(-3, 3, length = 50)
x2 = seq(-4, 4, length = 60)
f <- function(x1, x2){
  x1^2 + x2^2 + x1*x2
}
y <- outer(x1,x2,FUN=f)
persp(x1,x2,y)

### latice 패키지를 이용한 3차원 그래프
library(lattice)

# 구간으로 나눈 3차원 그래프
data("quakes")
mini = min(quakes$depth) # 최대 최소 지정
maxi = max(quakes$depth)
r = ceiling((maxi-mini)/8) # 구간 크기
inf = seq(mini, maxi, r) # 구간 생성
quakes$depth.cat = factor(floor((quakes$depth - mini)/r), 
                          labels = paste(inf, inf+r, sep = "-"))
xyplot(lat~long|depth.cat, data=quakes, main="Fiji earthquakes")

# 3차원 그래프
cloud(mag~lat*long, data=quakes, sub = "magnitude with long lat")

# 3차원 데이터의 관계성을 보여줌 - 4
splom(quakes[, 1:4])