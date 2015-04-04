library(plyr)
library(ggplot2)
library(gridExtra)

counts = count(data.read, c("target", "variable"))
count.all = count(data.read, c("target"))

freq2 = counts$freq / count.all$freq[counts$target]

counts = cbind(counts, freq2)

#make a plot of this

plots = NULL

pairs = 2

for(ids in combn(1:9,pairs, simplify=F)){
    
  g.stack = ggplot(counts[counts$target %in% ids,], aes(factor(variable), freq2, fill=target)) + 
    geom_bar(stat="identity"
             #, position="fill"
             ) + 
    scale_fill_brewer(palette="Set1", limits=levels(counts$target))
  
  plots = c( plots, list(g.stack))
  
}

filename = paste0("plot_",pairs,"_dodge_norm.png")
png(filename, w=3000,h=5000)

do.call(grid.arrange, c(plots, list(ncol=2)))

dev.off()