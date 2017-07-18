setwd("/Users/yoon/Documents/DataScience/R_work/visualization")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

### dotgraph : 자료 특성 보기에 유용
x <- c(1:10)
dotchart(x, labels = paste("TEST", 1:10), pch = 22)

### histogram : 빈도 파악에 유용
hist(rnorm(1:100))

### pie graph
T_sales <- c(210, 110, 400, 550, 700, 130)
pie(T_sales)

# angle, density, col : 각도, 밀도, 색상의 지정
# labels : 도나쓰의 각 부분 이름 서열정리
# radius, clockwise
# init.angle : 시작지점 결정

pie(T_sales, init.angle = 90, col = rainbow(length(T_sales)), 
    labels = c("M","T","W","T","F","S"))
legend(1,1, c("M","T","W","T","F","S"), cex = 0.8, fill = rainbow(length(T_sales)))

### label processing
week <- c("M","T","W","T","F","S")
ratio <- round((T_sales/sum(T_sales)*100), 1)
label <- paste(week, " \n", ratio, "%")
pie(T_sales, init.angle = 90, col = rainbow(length(T_sales)), 
    labels = label)

### 3 dimension pie graph
library(plotrix)
week <- c("M","T","W","T","F","S")
ratio <- round((T_sales/sum(T_sales)*100), 1)
label <- paste(week, " \n", ratio, "%")

pie3D(T_sales, main = "주간 매출 변동", col = rainbow(length(T_sales)), 
      cex=0.8, labels = label, family="AppleGothic", explode = 0.1)
# explode : 도나쓰 갈라놓은 정도
legend(1,1, c("M","T","W","T","F","S"), cex = 0.8, fill = rainbow(length(T_sales)))

### box graph
abc <- c(110, 300, 150, 280, 310)
def <- c(180, 200, 210, 190, 170)
ghi <- c(210, 150, 260, 210, 70)
boxplot(abc, def, ghi)

# col : 상자 내부 색
# names : 각 막대 이름
# width : 박스 폭 지정
# notch : T -> 상자 허리 가늘게
# horizontal : T -> 상자 수평으로 그리기