setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

# 평균 180, 표준편차 10인 100개의 표본추출
data1 = rnorm(100, mean=180, sd=10)

t.test(x=data1, mu=180)
t.test(x=data1, mu=200)
# t test 는 두 집단의 평균이 같은지를 검정하는 것.
# t값은 z값과 비슷한 개념으로, -4~4 사이의 값으로 나오면 정상적인 범주에 속하는 것.
# p-value는 귀무가설에서 통계량 이상일 확률을 나타낸 것. 예를들어 모집단 평균이 180인데
# 표본추출 결과 평균이 200점 이상이 나올 확률이 0.00001 이면 일어나기 매우 희박한 상황.
# 즉, p-value가 0.05 이하이면 귀무가설이 기각되는 것이다.
# 등분산성은 분산분석을 통해 서로 다른 두개 이상의 집단을 비교할때, 분산이 얼마나 같은지에 대한 것.
# 등분산성 검정 겱과 p-value가 매우 낮은 경우 등분산이 아니라는 것을 의미한다.

data2 = rnorm(100, mean=160, sd=5)

var.test(x=data1, y=data2)
t.test(x=data1, y=data2, var.equal = F)
