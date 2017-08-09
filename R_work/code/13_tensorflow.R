setwd("/Users/yoon/Documents/DataScience/R_work") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

# devtools::install_github("rstudio/tensorflow", force=T) : 설치 완료

library(tensorflow)
sess <- tf$Session()
hello <- tf$constant("hello tens")
sess$run(hello)

flags <- tf$app