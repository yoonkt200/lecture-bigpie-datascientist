##-----------------------------------R 예제  H2o----------------------------------##

wine<-read.table('https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data',sep=',')
colnames(wine)<-c('class', 'Alcohol', 'Malic acid', 'Ash', 'Alcalinity of ash',
                  'Magnesium', 'Total phenols', 'Flavanoids', 'Nonflavanoid phenols', 
                  'Proanthocyanins','Color intensity','Hue',
                  'OD280/OD315 of diluted wines', 'Proline')

set.seed(2016)

splwine <- split(wine,wine$class)
tab <- table(wine$class)
numlist <- splspacetr <- splspacete<-list() 
tr<-te<-data.frame()

for(i in 1:length(tab))
{
  numlist[[i]]<-sample(1:tab[i],.6*tab[i],replace=F)
  splspacetr[[i]]<-splwine[[i]][numlist[[i]],]
  splspacete[[i]]<-splwine[[i]][-numlist[[i]],]
  tr<-rbind(tr,splspacetr[[i]])
  te<-rbind(te,splspacete[[i]])
}

tr$class<-as.factor(tr$class)
te$class<-as.factor(te$class)
dimen<-dim(tr)

install.packages("h2o")
library(h2o)

h2o.init()
tr2<-as.h2o(tr)
te2<-as.h2o(te)

h2odnn<-h2o.deeplearning(x=2:14,y=1,activation="Rectifier",
                         train_samples_per_iteration=10,epoch=20,
                         hidden=c(5,4),training_frame=tr2,validation_frame=te2,
                         input_dropout_ratio=0.2, hidden_dropout_ratios=c(0.5,0.5) )
pre<-h2o.predict(h2odnn,te2)
h2o.confusionMatrix(h2odnn,te2)

##------------------------------------R 예제  DARCH----------------------------------##

wine<-read.table('https://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data',sep=',')
colnames(wine)<-c('class', 'Alcohol', 'Malic acid', 'Ash', 'Alcalinity of ash',
                  'Magnesium', 'Total phenols', 'Flavanoids', 'Nonflavanoid phenols', 
                  'Proanthocyanins','Color intensity','Hue',
                  'OD280/OD315 of diluted wines', 'Proline')

set.seed(2016)

splwine <- split(wine,wine$class)
tab <- table(wine$class)
numlist <- splspacetr <- splspacete<-list() 
tr<-te<-data.frame()

for(i in 1:length(tab))
{
  numlist[[i]]<-sample(1:tab[i],.6*tab[i],replace=F)
  splspacetr[[i]]<-splwine[[i]][numlist[[i]],]
  splspacete[[i]]<-splwine[[i]][-numlist[[i]],]
  tr<-rbind(tr,splspacetr[[i]])
  te<-rbind(te,splspacete[[i]])
}

tr$class<-as.factor(tr$class)
te$class<-as.factor(te$class)
dimen<-dim(tr)

install.packages("darch")
library(darch)

tr_darch <- darch(x=tr[,2:14],y=tr[,1], layers = c((dimen[2]-1),5,4,3) ,
                preProc.params=T , normalizeWeights=F , rbm.batchSize=10 , 
                rbm.lastLayer=T , rbm.learnRate=.2 , 
                rbm.weightDecay=2e-04 , rbm.initialMomentum=.3 ,
                rbm.finalMomentum=.9 , rbm.momentumRampLength=1,
                rbm.numEpochs=1000,
                darch.batchSize = 10, darch.dropout=c(0.2,0.5,0.5), darch.numEpochs = 1000)
                
pred <- predict(tr_darch, newdata=te[,2:14], type="class")
table(te$class, pred)
mean(pred!=te$class)


##------------------------------------R 예제  Autoencoder----------------------------------##

install.packages("autoencoder")
library(autoencoder)
data(iris)
iris.x<-iris[,1:4]
set.seed(2016)
fit <- autoencode(as.matrix(iris.x),
 nl=3,                 # 층의 개수 (디폴트 3: 입력층, 은닉층, 출력층)
 N.hidden=2,          # 은닉노드의 개수
 unit.type="logistic",   # 은닉층의 활성함수
 rho=0.3,             # desired sparsity parameter
 lambda=1e-5,        # 가중치 감소 매개변수
 beta=1e-5,           # 희박성 벌칙항 매개변수
 epsilon=0.1,   # 정규분포 N(0,e^2 )로부터 난수를 발생하여 가중치의 초기값으로 사용 
 optim.method=c("BFGS"), #목적함수의 최소값을 찾기 위한 최적화 방법 설정
 rescale.flag=T       #표준화 또는 척도화 여부 결정
                 )

pred <- predict(fit, as.matrix(iris.x), hidden.output = T)
new <- cbind(pred$X.output, iris[,5])
                  feature1 <- pred$X.output[,1]
                  feature2 <- pred$X.output[,2]
                  plot(feature1, feature2, col=new[,3], pch=new[,3])
                  legend(0.6, 0.5, legend=c("setosa", "versicolor","virginica"), col=1:3, pch=1:3)
                  

##-----------------------------R 예제  Stacked Denoising Autoencoder----------------------------#

install.packages("RcppDL")
library(RcppDL)

ionurl  <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data'

names = c('V1', 'V2', 'V3', 'V4','V5', 'V6','V7', 'V8', 'V9', 'V10',
          'V11', 'V12', 'V13', 'V14','V15', 'V16','V17', 'V18', 'V19', 'V20',
          'V21', 'V22', 'V23', 'V24','V25', 'V26','V27', 'V28', 'V29', 'V30',
          'V31', 'V32', 'V33', 'V34','Class')

ionosphere = read.table(ionurl, header=F, sep =',', col.names=names)

set.seed(2016)

sample <- sample(1:351, floor(351*0.6), FALSE)

train <- 
matrix(as.numeric(unlist(ionosphere[sample,])), nrow=nrow(ionosphere[sample,]))
test <- 
matrix(as.numeric(unlist(ionosphere[-sample,])),nrow=nrow(ionosphere[-sample,]) )

x_train <- train[,-35]
x_test <- test[,-35]

y_train <- train[,35]
p_y_train <- (y_train ==1)
                  temp1 <- ifelse (p_y_train==FALSE, 1 , 0)
                  y_train <- cbind(p_y_train, temp1)
                  
                  y_test <- test[, 35]
                  p_y_test <- (y_test ==1)
                  temp2 <- ifelse (p_y_test==FALSE, 1 , 0)
                  y_test <- cbind(p_y_test, temp2)
                  
                  hidden = c(50,50,50)
                  fit <- Rsda(x_train, y_train, hidden)  #누적 잡음제거 오토인코더 생성
                  
                  setCorruptionLevel (fit, x =0.25)     #잡음 수준을 25%로 설정
                  summary(fit)
                  
                  pretrain(fit); finetune(fit)             #예비학습 및 세부조정
                  
                  predprob <- predict(fit,x_test)       #검정자료에 대한 예측확률 계산 
                  
                  pred <- ifelse(predprob[,1]>=0.5, 1, 0)
                  table(y_test[,1], pred,dnn=c("Observed","Predicted"))
                  

##-----------------------------R 예제  mxnet----------------------------#

# Package Installation
 install.packages("drat", repos="https://cran.rstudio.com")
 drat:::addRepo("dmlc")
 install.packages("mxnet")
 
 # 안될때 이거로 설치
 # cran <- getOption("repos")
 # cran["dmlc"] <- "https://s3.amazonaws.com/mxnet-r/"
 # options(repos = cran)
 # install.packages("mxnet")
 
 library(mxnet)

# Data preparation
 train<-read.csv('https://github.com/ozt-ca/tjo.hatenablog.samples/raw/master/r_samples/public_lib/jp/mnist_reproduced/short_prac_train.csv')
 test<-read.csv('https://github.com/ozt-ca/tjo.hatenablog.samples/raw/master/r_samples/public_lib/jp/mnist_reproduced/short_prac_test.csv')
 
 train <- data.matrix(train)
 test <- data.matrix(test)
 train.x <- train[,-1]
 train.y <- train[,1]
 train.x <- t(train.x/255) # mxnet 라이브러리는 행렬연산을 위해서 X변수를 반드시 트랜스 시켜야 함.
 test_org <- test
 test <- test[,-1]
 test <- t(test/255)
 table(train.y)

#=== Deep NN ===
 data <- mx.symbol.Variable("data")
 fc1 <- mx.symbol.FullyConnected(data, name="fc1", num_hidden=128)
 act1 <- mx.symbol.Activation(fc1, name="relu1", act_type="relu")
 fc2 <- mx.symbol.FullyConnected(act1, name="fc2", num_hidden=64)
 act2 <- mx.symbol.Activation(fc2, name="relu2", act_type="relu")
 fc3 <- mx.symbol.FullyConnected(act2, name="fc3", num_hidden=10)
 softmax <- mx.symbol.SoftmaxOutput(fc3, name="sm")
 devices <- mx.cpu()
 mx.set.seed(0)
 model <- mx.model.FeedForward.create(softmax, X=train.x, y=train.y,
                                      ctx=devices, num.round=10, array.batch.size=100,
                                      learning.rate=0.07, momentum=0.9,  eval.metric=mx.metric.accuracy,
                                      initializer=mx.init.uniform(0.07),
                                      epoch.end.callback=mx.callback.log.train.metric(100))

 preds <- predict(model, test)
 dim(preds)

 pred.label <- max.col(t(preds)) - 1
 table(pred.label)
 head(pred.label)
 table(test_org[,1],pred.label)
 sum(diag(table(test_org[,1],pred.label)))/1000

#==== Convolutional NN ====

# mxnet 은 symbolic 연산을 기반으로 함

 data <- mx.symbol.Variable('data')

 # first conv
 conv1 <- mx.symbol.Convolution(data=data, kernel=c(5,5), num_filter=20)
 tanh1 <- mx.symbol.Activation(data=conv1, act_type="tanh")
 pool1 <- mx.symbol.Pooling(data=tanh1, pool_type="max",
                            kernel=c(2,2), stride=c(2,2))
 # second conv
 conv2 <- mx.symbol.Convolution(data=pool1, kernel=c(5,5), num_filter=50)
 tanh2 <- mx.symbol.Activation(data=conv2, act_type="tanh")
 pool2 <- mx.symbol.Pooling(data=tanh2, pool_type="max",
                            kernel=c(2,2), stride=c(2,2))
 # first fullc
 flatten <- mx.symbol.Flatten(data=pool2)   # conv layer 마지막 부분을 1D로 변환
 fc1 <- mx.symbol.FullyConnected(data=flatten, num_hidden=500)
 tanh3 <- mx.symbol.Activation(data=fc1, act_type="tanh")

 # second fullc
 fc2 <- mx.symbol.FullyConnected(data=tanh3, num_hidden=10)

# loss
 lenet <- mx.symbol.SoftmaxOutput(data=fc2)
 train.array <- train.x
 dim(train.array) <- c(28, 28, 1, ncol(train.x))
 test.array <- test
 dim(test.array) <- c(28, 28, 1, ncol(test))

 mx.set.seed(0)
 tic <- proc.time()

 model <- mx.model.FeedForward.create(lenet, X=train.array, y=train.y,
                                      ctx=devices, num.round=20, array.batch.size=100,
                                      learning.rate=0.05, momentum=0.9, wd=0.00001,
                                      eval.metric=mx.metric.accuracy,
                                      epoch.end.callback=mx.callback.log.train.metric(100))

print(proc.time() - tic)

preds <- predict(model, test.array)
pred.label <- max.col(t(preds)) - 1
table(test_org[,1],pred.label)
sum(diag(table(test_org[,1],pred.label)))/1000

