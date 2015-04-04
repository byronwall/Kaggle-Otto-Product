#make a plot of data using data.read
library(ggplot2)


#this one generates the charts from before
ids = 1:10

data.read$target = factor(data.read$target)

data.plot = data.read[data.read$variable %in% ids,]
data.plot$value[data.plot$value > 10] = 12

g = ggplot(data.plot, aes(value, 0, colour=target)) +
  geom_point(size=1, position = position_jitter(w = 0.3, h=1)) +
  scale_colour_brewer(palette="Set1") + xlim(0,12.5)

plot(g + facet_grid( variable ~ .))

#this chart plots the total for each group for each feature

g.stack = ggplot(data.read, aes(factor(variable), fill=factor(target))) + 
  geom_bar() + 
  scale_fill_brewer(palette="Set1")

plot(g.stack)

#this one facets the counts -- looks good
g.stack = ggplot(data.read, aes(factor(variable), fill=factor(target))) + 
  geom_bar() + 
  scale_fill_brewer(palette="Set1") + 
  facet_grid(target~.)

plot(g.stack)

#this one makes the plot with freq lines -- not that good
g.stack = ggplot(data.read, aes(factor(variable), color=target)) + 
  geom_freqpoly(aes(group=target)) + 
  scale_color_brewer(palette="Set1")

plot(g.stack)

#this section will create the feat x feat plots

data.plot2 = data.read
data.plot2$value[data.plot2$value > 10] = 12

library(data.table)
dt = data.table(data.plot2, key=c("id"))
dt2 = copy(dt)

#this is the merge.  it works.  the extra param is needed to make it work.
dt3 = dt[dt2, allow.cartesian=T]

#this merge joins them togetehr if the same ID is in both lists
feat_12 = merge(x = data.plot2, y = data.plot2, by="id", all=F)


for(row_ind in 1:12){
  for(col_ind in 1:12){
    png(paste0("plots/xplots/cross_plot",row_ind,"-",col_ind,".png"), width=4000, height=4000)
    
    edge1 = row_ind*8
    edge11 = edge1 - 7
    edge2 = col_ind*8
    edge21 = edge2-7
    
    range1 = edge11:edge1
    
    g.feat = ggplot(dt3[variable %in% edge11:edge1 & i.variable %in% edge21:edge2,],
                    aes(value, i.value, color=target)) +
      geom_point(size=1, position = position_jitter(w = 0.35, h=0.35)) +
      scale_color_brewer(palette="Set1") + 
      facet_grid(variable ~ i.variable)
    plot(g.feat)
    
    dev.off()
  }
}