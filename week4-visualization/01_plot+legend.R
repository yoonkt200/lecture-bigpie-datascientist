setwd("/Users/yoon/Documents/DataScience/week4_Visualization") 

### 액셀 그래프는 지도나 이런 것들은 불가능. but R 그래프는 할 수 있다

### 간단한 데이터셋
abc <- c(260, 300, 250, 280, 310)
def <- c(180, 200, 210, 190, 170)
ghi <- c(210, 250, 260, 210, 270)

### 화면 분할
m <- par(mfrow=c(1,3))

### 간단한 그래프 타입 종류
plot(abc, type="o")
plot(abc, type="o", col="red", ylim=c(0,400), axes = F, ann = F)
# 그래프만 그리기 : y 범위, 축 보이기 여부, 축 이름 보이기 여부설정
plot(def, type="s")
plot(ghi, type="b")

title(main="Fruit", col.main="red", font.main=4) # 그래프 전체 title
title(xlab = "Day", col.lab="black") # lab(축) 관련 title

### 그래프 중첩
lines(def, type = "o", pch=21, col="green", lty=2) # lty : 선 종류
lines(ghi, type = "o", pch=22, col="blue", lty=2)
plot(sin, -pi, pi, lty=2)
par(new=T) # par를 하게 되면 그래프 위에 덮어 쓰는 것을 의미 : 중첩
plot(cos, -pi, pi, lty=2)

### 범례 넣기
plot(abc, type="o", col="red", ylim=c(0,400), axes = F, ann = F)
par(new=T)
plot(def, type="o", col="green", ylim=c(0,400), axes = F, ann = F)
par(new=T)
plot(ghi, type="o", col="blue", ylim=c(0,400), axes = F, ann = F)
axis(1, at=1:5, lab=c("A","B","C","D","E"))
axis(2, ylim=c(0,400))
legend(4,400, c("BaseBall", "SoccerBall", "BeachBall"), cex = 0.8,
       col=c("red","green","blue"), pch = 21, lty = 1:3)

### pdf 파일저장 : 완벽히 저장 되려면 R을 종료 시킨 후 pdf file을 확인
dev.copy(pdf, "sampleFile.pdf")
dev.off

### 산포도 형태의 그래프
x <- seq(1, 10, 0.1)
y <- exp(x)
plot(x,y)

m <- par(mfrow=c(1,1))
plot(ToothGrowth)
plot(ToothGrowth$len, ToothGrowth$dose, main="my first graph",
     xlab = "Drink Soje", ylab = "Use Money", col = "red")

# col : 색 지정
# pch : 점의 모양 지정
# bg : 배경색 지정
# lwd : 선의 굵기
# cex : 점의 굵기
