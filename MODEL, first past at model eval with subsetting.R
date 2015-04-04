#this code will divide out the classes to show "group" inclusion

#need nine elements to show inclusion
#set.seed(55)

source(file = "FUNC, nnet eval.R")

#create the grouped classes for testing
groups = factor(paste0("C", 1:2))
group = sample(groups, 9, replace=T)

runs = 1:500

results = NULL

for(run in runs){
  
  #choose the features to include
  keep_max = 4:10
  keeps = sample(93,sample(keep_max, 1)) 
  
  results = rbind(results, as.data.frame(eval_combo(group, keeps, 0.1)))
}