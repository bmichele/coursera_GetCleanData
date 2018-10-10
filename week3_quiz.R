rm(list = ls())
setwd("/home/miche/Repositories/coursera_GetCleanData")

#-------------#
# Quiz week 2 #
#-------------#

##
## Question 1 
##

# The American Community Survey distributes downloadable data about United
# States communities. Download the 2006 microdata survey about housing for the
# state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is
# here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#
# Create a logical vector that identifies the households on greater than 10
# acres who sold more than $10,000 worth of agriculture products. Assign that
# logical vector to the variable agricultureLogical. Apply the which() function
# like this to identify the rows of the data frame where the logical vector is
# TRUE.
#
# which(agricultureLogical)
#
# What are the first 3 values that result?
#

# I download and read the data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
# I create a directory for the data
if(!file.exists("./data")) dir.create("./data")
# I download and store the data in the directory
if(!file.exists("./data/idahoHousing.csv")){
    download.file(fileURL,destfile = "./data/idahoHousing.csv")
}
# I read the data
data <- read.csv("./data/idahoHousing.csv",na.strings = "NA")

# I create a logical vector containing indices for which ACR = 3 and AGS = 6 and
# I compute the result
agricultureLogical <- (data$ACR == 3 & data$AGS == 6)
res <- head(which(agricultureLogical),n=3)

print("Answer to question 1 is:")
print(res)

##
## Question 2
##

# Using the jpeg package read in the following picture of your instructor into R
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the
# resulting data? (some Linux systems may produce an answer 638 different for
# the 30th quantile)
#

# I download and store the picture in the directory
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
if(!file.exists("./data/jeff.jpg")){
    download.file(fileURL,destfile = "./data/jeff.jpg")
}
# I read the jpeg file
library(jpeg)
dataJPG <- readJPEG("./data/jeff.jpg",native = TRUE)

q3 <- quantile(dataJPG,probs = seq(0,1,0.3))
q2 <- quantile(dataJPG,probs = seq(0,1,0.2))

print("Answer to question 2:")
print("The 30th quantile is given by")
print(q3[2])
print("The 80th quantile by")
print(q2[5])

##
## Question 3
##

# Load the Gross Domestic Product data for the 190 ranked countries in this data
# set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank (so United States is
# last). What is the 13th country in the resulting data frame?
#    Original data sources:
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats
#

# I download and read the data
fileURL1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileURL2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
# I download and store the data in the directory
if(!file.exists("./data/GDP.csv")){
    download.file(fileURL1,destfile = "./data/GDP.csv")
}
if(!file.exists("./data/ed-stats.csv")){
    download.file(fileURL2,destfile = "./data/ed-stats.csv")
}
# I read the data
dataGDP <- read.csv("./data/GDP.csv")
dataEDU <- read.csv("./data/ed-stats.csv")

# I clean the dataframe dataGDP
library(dplyr)
dataGDP <- dataGDP[-(1:4),] # remove the first incomplete rows
dataGDP <- rename(dataGDP,
                  state.id = X,
                  ranking = Gross.domestic.product.2012,
                  gdp = X.3) # I rename the columns in a sensible way
dataGDP <- select(dataGDP,c(ranking,state.id,gdp))
# I transform factor to number in ranking and gdp column and into char for
# state.id values
dataGDP$ranking <- as.numeric(as.character(dataGDP$ranking))
dataGDP$gdp <- as.numeric(gsub(",","",as.character(dataGDP$gdp)))
dataGDP$state.id <- as.character(dataGDP$state.id)
# I know that there are 190 countries, so I remove listings for which
# ranking > 190
dataGDP <- filter(dataGDP,ranking <= 190)

# I also change to char the country codes into dataEDU
dataEDU$CountryCode <- as.character(dataEDU$CountryCode)

print("Answer to question 3:")
print("The number of matching country IDs is ")
print(length(intersect(unique(dataEDU$CountryCode),unique(dataGDP$state.id))))

dataGDP <- arrange(dataGDP,desc(ranking))

print("13th country in descending order by GDP rank is ")
print(dataGDP$state.id[13])

##
## Question 4
##

# What is the average GDP ranking for the "High income: OECD" and
# "High income: nonOECD" group?
#

# I need to merge the dataframes by country id
data <- merge(dataGDP,dataEDU,by.x = "state.id", by.y = "CountryCode")
data <- rename(data,rank.gdp = ranking)

# # I add two categorical variables to specify wether countries have Income.Group
# # as High income: OECD" and "High income: nonOECD" or not
# data <- mutate(data, cat.OECD = (Income.Group == "High income: OECD"))
# data <- mutate(data, cat.nonOECD = (Income.Group == "High income: nonOECD"))
# # the result can be checked looking at the output of
# table(data$Income.Group,data$cat.OECD)
# table(data$Income.Group,data$cat.nonOECD)

# then I can look at the desired value printing the following dataframe
GDP.average.by.group <- group_by(data,Income.Group)%>% summarize(GDP.av.rank = mean(rank.gdp))
print("The average GDP ranking for each group is given by")
print(arrange(GDP.average.by.group,GDP.av.rank))

##
## Question 5
##

# Cut the GDP ranking into 5 separate quantile groups. Make a table versus
# Income.Group. How many countries are Lower middle income but among the 38
# nations with highest GDP?

data$rankGroups <- cut(data$rank.gdp,
                       breaks = quantile(data$rank.gdp,
                                         probs = seq(0,1,length.out = 6)
                                         )
                       )
table <- table(data$rankGroups,data$Income.Group)

print("Answer to question 4 can be read off the following table")
print(table)