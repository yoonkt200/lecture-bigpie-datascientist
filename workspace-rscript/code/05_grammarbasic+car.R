setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

#### 데이터 자료형 정리
# 값 한개만 가지고 있는 변수를 스칼라라고 함.
a = 5
a2 = "a"

# 한 행에 여러 열이 있는 변수를 벡터라고 함
a3 = 1:3
a4 = c("a", 3, "Awd")

# 매트릭스 : 행과 열을 가진 것
a5 = matrix(1:15, nrow=3)

a6 = array(dim=c(3,2,3))
a7 = data.frame(1:3, rep(1:3), LETTERS[5:7])
# data frame은 데이터 구조 안에 열별로 여러 타입을 넣을 수 있음.
str(a6)
str(a7)
a7$X1.3

a8 = list(a,a2,a3,a4,a5,a6,a7)

a9 = a7[2]
str(a9)
a10 = as.matrix(a7)
str(a10)
View(a10)

rownames(iris[which(iris$Sepal.Length>=6.5), ])

# install.packages('mlbench')
library(mlbench)
data("Vowel")
View(Vowel)

# vowel에서 소문자 i가 들어있는 데이터를 찾을 때
# grep function -> data frame에서 search 함수로 주로 쓰임
idx_list = grep('i', Vowel$Class) # return index
v1 = Vowel[idx_list, ]
View(v1)

###
# install.packages("car")
library(car) # ANOVA등의 검증 관련 모음
leveneTest(Sepal.Length ~ Species, iris) # 그룹이 다수일때의 등분산 검정
