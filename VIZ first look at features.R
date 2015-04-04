library("data.table")
library("ggplot2")

data.train = read.table("data//train.csv", header=T, sep=",")
data.train$target = factor(data.train$target)

#this code will analyze a given feature

plot_data = NULL

feats = ncol(data.train)-1
#feats = 5

for(i in 2:feats){
  
  #these two lines are used to get non-zero entries only
  indices = as.vector(data.train[,i] != 0)    
  feat = as.vector(data.train[indices, i])
  feat[feat>10] = 12
  targets = factor(as.vector(data.train[indices, "target"]))
  
  # y is used to jitter across the y axis
  
  plot_data = rbind(plot_data, data.frame(x = feat, jitter = 0, feat=i, group=targets))
  
  if(i%%31 == 0){
    g = ggplot(plot_data, aes(x, jitter, colour=group)) +
      geom_point(size=1, position = position_jitter(w = 0.3, h=1)) +
      scale_colour_brewer(palette="Set1") + xlim(0,12.5)
    
    png(paste0("plot",i,".png"), width=1200, height=15*300)
    plot(g + facet_grid( feat ~ .))
    dev.off()
    
    plot_data = NULL
  }
}


