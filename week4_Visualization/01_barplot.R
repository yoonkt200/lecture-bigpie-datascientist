setwd("/Users/yoon/Documents/DataScience/week4_Visualization")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

### 막대그래프 기본
x <- c(1,2,3,4,5,6)
barplot(x, names = "매출", family = "AppleGothic")

### matrix 자료형 column 기준으로 막대그래프.
xx <- matrix(c(1,2,3,4,5,6), 3, 2)
barplot(xx)
barplot(xx, beside= F, names=c("Korea", "America"))
barplot(xx, beside= T, names=c("Korea", "America"))

xxx <- matrix(c(1,2,3,4,5,6), 2,3)
barplot(xxx, beside = T, names=c("Korea", "America", "Europe"))

# angle, density, col : 막대를 칠하는 선의 각도, 수, 색을 정함
# legend : 범례
# names : 막대 라벨
# width : 막대의 상대적인 폭
# space : 막대사이 간격
# beside : 각각의 값마다 막대를 그림
# horiz : 막대를 눕혀서 그림

### 옵션 테스트
abc <- c(110, 300, 150, 280, 310)
barplot(abc, main="Base Ball 판매량", xlab = "Season", ylab = "판매량",
        names.arg = c("A","B","C","D","E"), border = "blue", 
        density = c(10,30,50,30,10), family = "AppleGothic")

### 응용 막대그래프
abc <- c(110, 300, 150, 280, 310)
def <- c(180, 200, 210, 190, 170)
ghi <- c(210, 150, 260, 210, 70)
B_type <- matrix(c(abc,def,ghi), 5,3)

barplot(B_type, main="Base Type별 시즌의 판매량", xlab = "Ball type", ylab = "판매량",
        beside=T, names.arg = c("BaseBall","SoccerBall","BaseBall"), border = "blue", 
        col=rainbow(5), ylim = (c(0,400)), family = "AppleGothic")
legend(16,400, c("A","B","C","D","E"), cex = 0.8, fill=rainbow(5))

### 응용2
barplot(t(B_type), main="시즌별 볼 타입에 따른 판매량", xlab = "Season", ylab = "price",
        beside=T, names.arg = c("A","B","C","D","E"), border = "blue", 
        col=rainbow(3), ylim = (c(0,400)), family = "AppleGothic")
legend(16,400, c("BaseBall","SoccerBall","BaseBall"), cex = 0.8, fill=rainbow(3))

