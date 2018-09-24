rm(list = ls())

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

setwd("/home/miche/Repositories/coursera_GetCleanData")

# I create a directory for the data
if(!file.exists("./data")) dir.create("./data")

# I download and store the data in the directory
if(!file.exists("./data/idahoHousing.csv")){
    download.file(fileURL,destfile = "./data/idahoHousing.csv")
}

data <- read.csv("./data/idahoHousing.csv",na.strings = "NA")

#------------#
# Question 1 #
#------------#
# How many properties are worth $1,000,000 or more?
# Value is stored in column with name VAL.
# I start removing all rows with NA VAL values
dataClean <- data[!is.na(data$VAL),]
# then I count the rows of a selection of the dataframe for which VAL = 24
ans1 <- nrow(dataClean[dataClean$VAL==24,])
print("answer to question 1 is")
print(ans1)

#------------#
# Question 2 #
#------------#
# Use the data you loaded from Question 1. Consider the variable FES in the code
# book. Which of the "tidy data" principles does this variable violate? 
# Wrong:
# - Each tidy data table contains information about only one type of observation.
# - Each variable in a tidy data set has been transformed to be interpretable. 
# - Tidy data has no missing values

#------------#
# Question 3 #
#------------#
xlsxURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

# I download and store the data in the directory
if(!file.exists("./data/gas.xlsx")){
    download.file(xlsxURL,destfile = "./data/gas.xlsx")
}

library("xlsx")

# Read rows 18-23 and columns 7-15 into R and assign the result to a variable
dat <- read.xlsx("./data/gas.xlsx",
                 rowIndex = 18:23,
                 colIndex = 7:15,
                 sheetIndex = 1
                 )
print("answer to question 3 is")
print(sum(dat$Zip*dat$Ext,na.rm=T))

#------------#
# Question 4 #
#------------#
# Read the XML data on Baltimore restaurants from here:
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

# How many restaurants have zipcode 21231?

# I download and store the data in the directory
if(!file.exists("./data/restaurants.xml")){
    download.file(fileURL,destfile = "./data/restaurants.xml")
}

library("XML")

doc <- xmlTreeParse("./data/restaurants.xml",useInternal=TRUE)
rootNode <- xmlRoot(doc)
# rootNote has only one level, so I take it all
#data <- rootNode[[1]]
zipCodes <- xpathSApply(rootNode,"//zipcode",xmlValue)
# I compute the number of entries with zipcode 21231
res <- sum(zipCodes==21231)

print("answer to question 4 is")
print(res)

#------------#
# Question 5 #
#------------#
# Use again the Idaho housing data from question 1:

require("data.table")
library("data.table")
DT <- fread("./data/idahoHousing.csv",sep=",",header = TRUE)
