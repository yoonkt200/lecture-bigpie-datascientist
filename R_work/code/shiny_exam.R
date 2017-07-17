# install.packages("ggplot2")
setwd("/Users/yoon/Documents/DataScience/R_work/MinimalHTMLCode")
library(ggplot2)

mpg
table(mpg$class)
barplot(table(mpg$class), main="Base graphics")

ggplot(data=mpg, aes(x=class))+geom_bar()+ggtitle("ggplot2")

plot(x=1947:1962, y=longley$GNP, type='l', xlab = "Year", main = "Base graphics")
plot(x=longley$Year, y=longley$GNP, type='l', xlab = "Year", main = "Base graphics")

ggplot(longley, aes(x=1947:1962, y=GNP))+geom_line()+xlab("Year")+ggtitle("ggplot2")

# install.packages("shiny")
library(shiny)
runExample("01_hello")
runExample("08_html")

## 실행 runApp() 또는 runApp("/~shinyFiles/minimalExample") 괄호 안에 디렉토리명 지정

runGist(6571951)

## 소스 https://gist.github.com/ChrisBeeley/6571951

## rga package install, https://github.com/skardhamar/rga

## 애플리케이션의 실행과 공유
## 소스 다운로드 https://github.com/ChrisBeeley/GoogleAnalytics

runGitHub("GoogleAnalytics", "ChrisBeeley")

runApp()
