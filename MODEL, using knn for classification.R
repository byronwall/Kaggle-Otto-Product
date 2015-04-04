library(caret)
library(klaR)
library(e1071)

set.seed(44)

#this is done to improve speed
data.use = data.train[sample(nrow(data.train), 10000), ]
data.use$id = NULL

inTraining = createDataPartition(data.use$target, p=0.8, list=F)
training = data.use[inTraining,]
test = data.use[-inTraining,]

#this step takes some time
model = train(target ~ . , data=training,
              method='kknn',
              trControl=trainControl(method='cv', number=5),
              preProcess = c("center","scale"),
              tuneGrid=data.frame(kmax=c(15,25), distance=2, kernel="optimal"))

#these are also not that fast
probs = predict(model, newdata = test, type="prob")
prob.class = predict(model, newdata = test, type="raw")

plot(probs)
