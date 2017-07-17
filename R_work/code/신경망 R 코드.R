##----------------------------------------신경망 관련 R 함수 --------------------------------------------##

nnet(x, y, weights, size, Wts, mask,
     linout = FALSE, entropy = FALSE, softmax = FALSE,
     censored = FALSE, skip = FALSE, rang = 0.7, decay = 0,
     maxit = 100, Hess = FALSE, trace = TRUE, MaxNWts = 1000,
     abstol = 1.0e-4, reltol = 1.0e-8, ...)

neuralnet(formula, data, hidden = 1, threshold = 0.01,        
          stepmax = 1e+05, rep = 1, startweights = NULL, 
          learningrate.limit = NULL, 
          learningrate.factor = list(minus = 0.5, plus = 1.2), 
          learningrate=NULL, lifesign = "none", 
          lifesign.step = 1000, algorithm = "rprop+", 
          err.fct = "sse", act.fct = "logistic", 
          linear.output = TRUE, exclude = NULL, 
          constant.weights = NULL, likelihood = FALSE)

nn.train(x=X,y=Y, initW=NULL, initB=NULL,
         hidden=c(10,12,20), learningrate=0.58,
         momentum=0.74, learningrate_scale=1,
         activationfun="sigm", output="linear",
         numepochs=970, batchsize=60,
         hidden_dropout=0.5,
         visible_dropout=0.5)

mxnet::mx.symbol.Activation  <- c('relu', 'sigmoid', 'softrelu', 'tanh')


##------------------------------------신경망 관련 회귀함수추정 예제----------------------------------##

install.packages("nnet") 
install.packages("stats")
library(nnet)
library(stats)

MSE <- c()
for(i in 1:20){
  x1<-runif(50,0,1)
  x2<-rnorm(50,0,1)
  x3<-3*runif(50,0,1)^(1/3)
  e<-rnorm(50,0,0.2)
  y<-5*(4.5-64*x1^2*(1-x1)^2-16*(x1-0.5)^2)+4*exp(x2/2)+7*sin(pi*x3/4)+e
  dat<-data.frame(x1,x2,x3,y)
  SSE<-c(); 
  for(k in 1:30){
    nn<-nnet(y~.,data=dat,size=k,decay=0.01,linout=T)
    SSE[k]<-sum(nn$residuals^2)
  }
  best.size<-which.min(SSE)
  nn<-nnet(y~.,data=dat,size=best.size,decay=0.01,linout=T)
  MSE[i]<-sum(nn$residuals^2)/50
}
mean(MSE);sd(MSE)


##------------------------------------신경망 관련 분류 예제----------------------------------##

library(nnet)
data(iris)
samp <- c(sample(1:50,25), sample(51:100,25), sample(101:150,25))
iris.tr<-iris[samp,]
iris.te<-iris[-samp,]

ir1 <- nnet(Species~., data=iris.tr, size = 2, decay = 5e-4)
names(ir1)
summary(ir1)

y<-iris.te$Species
p<- predict(ir1, iris.te, type = "class")
(tt<-table(y, p))


#========= Hidden unit의 수에 따른 Test error ===================

test.err<-function(h.size)
{  ir <- nnet(Species~., data=iris.tr, size = h.size,decay = 5e-4, trace=F)
y<-iris.te$Species
p<- predict(ir, iris.te, type = "class")
err<-mean(y != p)
c(h.size, err)  }
out<-t(sapply(2:10, FUN=test.err))
plot(out, type="b", xlab="The number of Hidden units", ylab="Test Error")




