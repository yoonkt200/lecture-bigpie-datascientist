library(nnet)
# linout 파라미터 : one-hot encoding 관련 파라미터
# help 나와있는 파라미터 연구하기

model1 = nnet(x=dd1[, 1:5], y=dd1[, 6], size = 2, lineout=T)
model1$wts
model1$fitted.values

# one-hot encoding 등을 더욱 자유롭게 하기 위해 아래 패키지가 필요함.
library(neuralnet)
library(shiny)
