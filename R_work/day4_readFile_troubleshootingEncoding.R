setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

library(xlsx)

data1 = read.xlsx("23.xlsx", sheetIndex = 1, startrow = 2, header = T, fileEncoding="UTF-8")
data1 <- read_xlsx("23.xlsx")
View(data1)
# data1 = read.csv("price.csv", header = T, encoding = "UTF-8")
data1 = read.csv("price.csv", header = T, fileEncoding="euc-kr")

# data1 = read.csv("NHIS_OPEN_T60_2015_part1.csv", header = T, fileEncoding="euc-kr")
# con = file("NHIS_OPEN_T60_2015_part1.csv", "r", encoding="euc-kr")
# a = read.csv(con, nrows=30)
# close(con)
# View(a)

head(data1)
# Windows에서 Excel로 csv 파일을 저장할 때 UTF-8이 아닌 eur-kr로 저장하기 때문에 이렇게 해줘야됨.

# install.packages("readxl")
library(readxl)
mydata <- read_excel("전국건강증진센터표준데이터.xls")
