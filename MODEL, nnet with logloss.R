library(caret)
library(klaR)
library(e1071)
library(kknn)

set.seed(44)

#this is done to improve speed
data.use = data.train [sample(nrow(data.train), 1000), ]

# data.use = data.train
data.use$id = NULL

inTraining = createDataPartition(data.use$target, p=0.8, list=F)
training = data.use[inTraining,]
test = data.use[-inTraining,]

ctrl = trainControl(method="cv", number=5, classProbs = TRUE, summaryFunction = LogLosSummary)
#kknn grid = data.frame(kmax=c(15,25), distance=2, kernel="optimal")
#pcaNNet
grid = data.frame(size=c(10), decay=0.1)

model = train(target ~ ., data = training,
              method="nnet",
              metric = "LogLoss",
              maximize = FALSE,
              trControl = ctrl,
              tuneGrid = grid,
              MaxNWts = 2000)

confused = confusionMatrix(test$target, predict(model, newdata=test, type="raw"))
