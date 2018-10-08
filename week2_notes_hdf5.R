#----------------------#
# Package isntallation #
#----------------------#

rm(list = ls())
setwd("/home/miche/Repositories/coursera_GetCleanData")
# first installation requires
# source("http://bioconductor.org/biocLite.R")
# biocLite("rhdf5")

library(rhdf5)

# I create a file
if(file.exists("./example.h5")) file.remove("./example.h5")

created = h5createFile("example.h5")

# create groups within the file
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
# create a subgroup
created = h5createGroup("example.h5","foo/foobaa")

# you can wies the hdf5 file using h5ls()
h5ls("example.h5")

# write a matrix into specific group
A = matrix(1:10,nr=5,nc=2)
h5write(A,"example.h5","foo/A")
# also possible to write other objects
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B,"scale") <- "liter" # I set a scale to the comps of the array
h5write(B,"example.h5","foo/foobaa/B") # I write the array in the sbgroup

# I look into it using
h5ls("example.h5")

# It is also possible to pass directly datasets to a hdf5 file
df = data.frame(1L:5L,seq(0,1,length.out = 5),
                c("ab","cde","fghi","a","s"), stringsAsFactors = FALSE)
# a dataset can be inserted directly in the root of the hdf5
h5write(df,"example.h5","df")
h5ls("example.h5")

# READING DATA
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf = h5read("example.h5","df")
readA
readB
readdf

# with hdf5 we can easily write or read chunks of the file
# to replace three emelents in foo/A
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
readAnew = h5read("example.h5","foo/A")
readAnew
# to read only a part of foo/A
readPart = h5read("example.h5","foo/A",index=list(1:3,1))
readPart