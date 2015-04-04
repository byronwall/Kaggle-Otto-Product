library(RSQLite)

#need to read the data back into a frame now

drv = dbDriver("SQLite")
tfile = "data/data2.db"
con = dbConnect(drv, dbname = tfile)

data.read = dbReadTable(con, "data")
dbDisconnect(con)
