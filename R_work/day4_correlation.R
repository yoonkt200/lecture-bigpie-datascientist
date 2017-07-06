setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(MASS)
data('survey')

ss1 = survey[, "Height"]
ss1 = survey[survey$Sex=="Male", "Height"]
m1 = survey[survey$Sex=="Male", ]
f1 = survey[survey$Sex=="Female", ]

ss2 = na.omit(ss1)
mean(ss1)
mean(ss2)

t.test(ss2, mu=178)

ss3 = na.omit(survey[survey$Sex=="Female", "Height"])
t.test(ss2, ss3, var.equal = F, paired = F) 
# 짝을 이룬 표본에 대한 검정을 할때만 paired=T, var.equal은 var.test 결과에 따라 설정해주면 됨.

View(sleep)
var.test(extra~group, data = sleep)
t.test(extra~group, var.equal = T, data = sleep) # ???
t.test(extra~group, var.equal = T, data = sleep, paired = T) # ??? 
# paired T인 이유는, 그룹 1과 2과 전후관계로 짝지어져 있기 때문

# 어떨때는 낮은게 유의하고 어떨때는 높은게 유의함??
# --> t.test(a,b, data= ...) 에서 a,b가 비슷한 그룹이다 라는 것이 t.test의 귀무가설. 
# 즉 a,b가 비슷하다라는 가정 하에, pvalue가 높으면 비슷한거고 낮으면 다른거.


sleep1 = sleep[1:10, ]
sleep1$group2 = sleep[11:20, 1]
t.test(x=sleep1$extra, y=sleep1$group2, data=sleep1, var.equal=T, paired=T)