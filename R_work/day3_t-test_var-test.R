setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

# 평균 180, 표준편차 10인 100개의 표본추출
data1 = rnorm(100, mean=180, sd=10)

t.test(x=data1, mu=180)
t.test(x=data1, mu=200)
# t test 는 두 집단의 평균이 같은지를 검정하는 것.

data2 = rnorm(100, mean=160, sd=5)

var.test(x=data1, y=data2)
t.test(x=data1, y=data2, var.equal = F)
