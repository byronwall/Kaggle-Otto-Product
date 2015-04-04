#this code will create a database of the otto data

library(reshape2)
library(RSQLite)

data.train = read.table("data//train.csv", header=T, sep=",")

#need to create a table which includes object-feature-value, excludes targets

data.flat = melt(data.train, id=c("id","target"))

indices.keep = data.flat$value > 0

data.flat = data.flat[indices.keep, ]
#this forces things over to integer for the DB
data.flat$variable = as.integer(factor(data.flat$variable))
data.flat$target = as.integer(factor(data.flat$target))

drv = dbDriver("SQLite")
tfile = "data2.db"
con = dbConnect(drv, dbname = tfile)

dbWriteTable(con, "data", data.flat, overwrite=T)
dbDisconnect(con)

#this for targets