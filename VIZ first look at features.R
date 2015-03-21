library("data.table")
library("ggplot2")

data.train = read.table("data//train.csv", header=T, sep=",")

#this code will analyze a given feature

plot_data = NULL

feats = ncol(data.train)-1

for(i in 2:feats){
  
  #these two lines are used to get non-zero entries only
  indices = as.vector(data.train[,i,with=F] != 0)    
  feat = as.vector(data.train[indices, i, with=F])
  
  # y is used to jitter across the y axis
  y = runif(nrow(feat), -1, 1)
  
  plot_data = rbind(plot_data, data.frame(x = feat[[1]], jitter = y, feat=i))
}

g = ggplot(plot_data, aes(x, jitter)) + geom_point(size=1)

png("plot.png", width=1200, height=feats*300)
plot(g + facet_grid( feat ~ .))
dev.off()
