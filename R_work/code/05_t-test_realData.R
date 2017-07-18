setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(readxl)
g3 <- read_xlsx("23.xlsx", sheet = 1, col_names = T)
g3 <- g3[-1,]
g4 = g3[1:29, ] # 서청주 빼고 출력
colnames(g4) = c("지점","1시","2시","3시","4시","5시","6시","7시","8시","9시","10시","11시","12시","13시","14시","15시","16시","17시","18시","19시","20시","21시","22시","23시","24시")
g4 = g4[, 1:17]
g4 = na.omit(g4)
str(g4)

g4$`1시` <- as.numeric(g4$`1시`)
g4$`2시` <- as.numeric(g4$`2시`)
g4$`3시` <- as.numeric(g4$`3시`)
g4$`4시` <- as.numeric(g4$`4시`)
g4$`5시` <- as.numeric(g4$`5시`)
g4$`6시` <- as.numeric(g4$`6시`)
g4$`7시` <- as.numeric(g4$`7시`)
g4$`8시` <- as.numeric(g4$`8시`)
g4$`9시` <- as.numeric(g4$`9시`)
g4$`10시` <- as.numeric(g4$`10시`)
g4$`11시` <- as.numeric(g4$`11시`)
g4$`12시` <- as.numeric(g4$`12시`)
g4$`13시` <- as.numeric(g4$`13시`)
g4$`14시` <- as.numeric(g4$`14시`)
g4$`15시` <- as.numeric(g4$`15시`)
g4$`16시` <- as.numeric(g4$`16시`)

g4$q1 = apply(g4[, 2:7], 1, FUN=mean)
g4$q2 = apply(g4[, 8:13], 1, FUN=mean)
g4$q3 = apply(g4[, 14:17], 1, FUN=mean)

# 비교하기 전에 어떻게 비교할것인지를 정하고 분석 방법을 결정함. (pair들을 맞추거나 하는 문제)
var.test(g4$q2, g4$q3) # 등분산이라 할수있음
t.test(x=g4$q2, y=g4$q3, var.equal = T, paired = T) # 차이없다고 할수있음

# mean(as.matrix(g4[1, 2:7])) 참고 : matrix
# a3 = data.frame(a=1:7, b=11:17, c=letters[1:7]) 참고 : data.frame
# a3 = data.frame(1:7, 11:17, letters[1:7])