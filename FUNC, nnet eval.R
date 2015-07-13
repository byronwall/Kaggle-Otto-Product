
eval_combo = function(group, cut=0.2){
  
  library(caret)
  library(klaR)
  library(e1071)
  library(kknn)
  
  #load log loss functions
  source(file="caret, logloss summary functions.R")
  
  #this is done to improve speed
  inAnalysis = createDataPartition(data.train$target, p=cut, list=F)
  data.use = data.train [inAnalysis, ]
  
  data.use = cbind(data.use, group.include = group[data.use$target])
  
  # data.use = data.train
  
  #remove non-features, incl. target since there is a new class variable
  data.use$id = NULL
  data.use$target = NULL
  
  #now we need to pick some features  
  #ensure that group.include is included
  
  inTraining = createDataPartition(data.use$group.include, p=0.8, list=F)
  training = data.use[inTraining,]
  test = data.use[-inTraining,]
  
  ctrl = trainControl(method="cv", number=3, classProbs = TRUE, summaryFunction = LogLosSummary)
  #kknn grid = data.frame(kmax=c(15,25), distance=2, kernel="optimal")
  #pcaNNet
  grid = expand.grid(.nprune = c(30),.degree = c(1))
  grid = expand.grid(.mtry = c(20))
  
  model = train(group.include ~ ., data = training,
                method="rf",
                metric = "LogLoss",
                maximize = FALSE,
                trControl = ctrl,
                tuneGrid = grid #nnet params below
                )
  
  confused = confusionMatrix(test$group.include, predict(model, newdata=test, type="raw"))
  
  return(model$results)
  
}
