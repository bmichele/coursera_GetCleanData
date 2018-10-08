#-------------#
# Quiz week 2 #
#-------------#

rm(list = ls())
setwd("/home/miche/Repositories/coursera_GetCleanData")

##
## Questions 2 and 3
##

# I load the sqldf package to simulate SQL query commands
library(sqldf)

# I set the URL for the file to be considered
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

# I create a directory for the data
if(!file.exists("./data")) dir.create("./data")

# I download and store the data in the directory
if(!file.exists("./data/week2_quiz_data.csv")){
    download.file(fileURL,destfile = "./data/week2_quiz_data.csv")
}

myData <- read.csv("./data/week2_quiz_data.csv",na.strings = "NA")

##
## Question 4
##

#
#
# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from
# this page: http://biostat.jhsph.edu/~jleek/contact.html
#

con = url("http://biostat.jhsph.edu/~jleek/contact.html")
html = readLines(con)
close(con)

print("Answer to Question 4 is")
print(c(
    nchar(html[10]),
    nchar(html[20]),
    nchar(html[30]),
    nchar(html[100])
))

##
## Question 5
##

#
# Read this data set into R and report the sum of the numbers in the fourth of
# the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
#

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"

if(!file.exists("./data/week2_quiz_data.for")){
    download.file(fileURL,destfile = "./data/week2_quiz_data.for")
}

data <- readLines("./data/week2_quiz_data.for")

# I remove the first four lines (containing headers) and I read as a table
cleanData1 <- tail(data,-4)
cleanData2 <- gsub("-"," -",cleanData1)

write(cleanData2, file = "data.txt")
cleanData <- read.table("data.txt")
file.remove("data.txt")

print("Sum of the fourth column is")
print(sum(cleanData[,4]))
