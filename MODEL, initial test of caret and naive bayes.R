library(caret)
library(klaR)
library(e1071)

set.seed(42)

#this is done to improve speed
data.use = data.train[sample(nrow(data.train), 10000), ]

inTraining = createDataPartition(data.use$target, p=0.8, list=F)
training = data.use[inTraining,]
test = data.use[-inTraining,]

#this step takes some time
model = train(target ~ . - id, data=training,
              method='nb',
              trControl=trainControl(method='none',classProbs=T),
              tuneGrid = data.frame(usekernel=T, fL=0))

#these are also not that fast
probs = predict(model, newdata = test, type="prob")
prob.class = predict(model, newdata = test, type="raw")

plot(probs)
