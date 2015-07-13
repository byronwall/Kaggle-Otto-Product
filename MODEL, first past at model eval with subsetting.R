#this code will divide out the classes to show "group" inclusion

#need nine elements to show inclusion
#set.seed(55)

source(file = "FUNC, nnet eval.R")

#create the grouped classes for testing

runs = 1:1

results = NULL

for(run in runs){

  groups = factor(paste0("C", 1:2))
  group = sample(groups, 9, replace=T)  
  
  #choose the features to include
  keep_max = 4:10
  keep_count = sample(keep_max, 1)
  
  #sample on its own just randomizes a vector
  keeps = sample(c( rep(1, keep_count), rep(0, 93-keep_count)))
  
  results = rbind(results,
                  data.frame(as.data.frame(eval_combo(group, 0.1)), 
                    group=paste0(group, collapse="-")))
}