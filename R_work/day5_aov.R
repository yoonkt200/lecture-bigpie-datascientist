setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(MASS)
data("survey")
View(survey)

model1 = aov(Pulse ~ Exer, data=survey)
summary(model1)

model2 = aov(Sepal.Length ~ Species, data=iris)
summary(model2)

model3 = aov(Pulse ~ Exer+Smoke, data=survey)
summary(model3)
# F-value : Mean Sq / Residuals --> 집단간 평균에 잔차를 나눈 것. 
# 즉, 잔차가 클 수록 F가 낮아지는 것이므로 F는 큰게 좋은것.(?)

model3 = aov(Pulse ~ Exer*Smoke, data=survey) 
# ==> model3 = aov(Pulse ~ Exer+Smoke+Exer:Smoke, data=survey) 
# aov(A ~ B, ...) 에서 B에 따라서 A가 얼마나 의미있게 비슷한지에 관한 것.
# : 은 두 변수의 join을 의미, * 은 변수의 부분집합까지 다 보고 싶을 때
summary(model3)

t1 = TukeyHSD(model1, "Exer")
t1 # some-freq 의 경우 집단간의 심박수 차이가 있는 것.

#### 실제 데이터 적용
library(reshape2)
g5 = melt(g4, id=1:17)

model4 = aov(value~variable, data=g5)
summary(model4)

g6 = melt(g4[1:17], id=1)
model5 = aov(value~variable, data=g6)
summary(model5)
t14= TukeyHSD(model5, "variable")

t3 = as.matrix(t14$variable)
# rownames(t3[(which(t3[,4]<0.5)),]) ??? 