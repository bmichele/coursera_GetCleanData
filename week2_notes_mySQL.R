#---------------#
# mySQL Example # 
#---------------#
# see http://genome.ucsc.edu/goldenPath/help/mysql.html

rm(list = ls())

library("RMySQL")

ucscDB <- dbConnect(MySQL(),user="genome",host="genome-mysql.cse.ucsc.edu")
# I run a mySQL command using dbGetQuery
result <- dbGetQuery(ucscDB,"show databases;"); dbDisconnect(ucscDB);
# result contains all the databases available 
# we are interested in hg19 (it's a human genome)
hg19 <- dbConnect(MySQL(),
                  user="genome",
                  db="hg19",
                  host="genome-mysql.cse.ucsc.edu"
                  )
# let's have a look at the tables in the  choosen database (their names are
# stored in allTables)
allTables <- dbListTables(hg19)
# then we can see at the fields of a particular table (e.g. affyU133Plus2)
dbListFields(hg19,"affyU133Plus2")
# to see how many different rows are present, run the query
# select count(*) from table
dbGetQuery(hg19,"select count(*) from affyU133Plus2")
# the table can be read into a data.frame using dbReadTable()
affyData <- dbReadTable(hg19,"affyU133Plus2")
# to see how the dataframe looks like,
head(affyData)

# sometimes db are too big, so we must consider a subset from beginning. In
# order to do that, we SEND a query to the databese, and then we fetch the query
query <- dbSendQuery(hg19,
                     "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query)
# the query selects all rows from the seleted table (affyU133Plus2) with values
# of misMatches between 1 and 3. See the quantiles of the column misMatches with
quantile(affyMis$misMatches)

# it is possible to apply the query to only on the first 10 rows using
affyMisSmall <- fetch(query,n=10)
# the query should be cleared. When sending, it is still there. To clear the
# query from the remote server, run
dbClearResult(query)

# remember to disconnect the server when done!
dbDisconnect(hg19)
# this should be done as soon as the connection is not needed anymore