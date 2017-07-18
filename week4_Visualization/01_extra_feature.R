setwd("/Users/yoon/Documents/DataScience/week4_Visualization")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

### 그림 덮어쓰기와 그림 삭제
plot(rnorm(1:10), col = "red")
par(new=T) # 그림 이어쓰기
plot(rnorm(1:10), col = "blue")
par(new=T)
plot.new() # 그림 삭제

# 적용
plot(-4:4, -4:4, type = "n") # 틀 그리기
points(rnorm(200), rnorm(200), pch="+", col="red") 
points(1,1, pch="+", col="blue")

### 꺾은선 그래프 그리기
x <- c(1:10)
y <- x*x
plot(x, y, type = "n", main="Title") # 틀 그리기
for (i in 1:5){
  lines(x, (y+i*5), col=i, lty=i)
}

# lines의 정체
lines(x, y, col="red", lty=1)

### 선분, 화살표, 문자열 그리기
x <- c(1,3,6,8,9)
y <- c(12,56,78,32,9)
plot(x,y)

segments(6,78, 8,32) # (6,78), (8,32) 두 좌표간의 직선 그리기
arrows(6,78, 8,32) # 두 좌표간의 화살표 그리기
rect(4,20, 6,30, density = 30) # 대각선 두 좌표
text(4,40, "hello world") # 글씨 추가

box(lty=2, col="red") # 테두리 그리기
axis(2, pos=5, at=10:60, col=2)# 축 그리기
axis(1, pos=40, at=4:10, col=2)# 축 그리기
# axis, 다른 축의 좌표, at, col

### 중복을 특이하게 표현하는 산포도
x <- c(1,1,1,2,2,2,2,2,2,3,3,4,5,6)
y <- c(2,1,4,2,3,2,2,2,2,2,1,1,1,1)
zz <- data.frame(x, y)
sunflowerplot(zz)

### 여러 항목을 가지는 데이터들을 한눈에 비교할 때
data("mtcars")
stars(mtcars[, 1:4]) # 1:4 column의 요소를 스탯으로 시각화함.