setwd("/Users/yoon/Documents/DataScience/R_work/visualization")
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

### 그림 덮어쓰기와 그림 삭제
plot(rnorm(1:10), col = "red")
par(new=T) # 그림 이어쓰기
plot(rnorm(1:10), col = "blue")
par(new=T)
plot.new() # 그림 삭제

