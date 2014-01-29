# 02-sortAna.R
# First use load to retrive the analyis infor from the 'wipeTest.RData'
# file. Then use dget to retrieve the raw analysis data frame as an 
# R object in the project data directory. Split the analysis data
# into data frames for alpha standards, beta standards, blanks,
# and samples. Save these in the the 'wipeTest.RData' file for
# subsequent processing.

rm(list=ls())

source('./00-functions.R')

# by convention
dat.dir <- '../dat/'
str.ana.file <- paste(dat.dir,'wipeTest.RData')
load(str.ana.file)

str.file <- paste(dat.dir, str.ana, '-raw.R', sep='')
data <- dget(str.file)

alpha.stds <- subset(data, data$id=="Am-241")
beta.stds  <- subset(data, data$id=="Cl-36")
blanks     <- subset(data, data$id=="blank")
samp       <- subset(data, data$id!="Am-241")
samp       <- subset(samp, samp$id!="Cl-36")
samples    <- subset(samp, samp$id!="blank" )

rm(samp, data)

# save what we need in the analysis file
save(str.ana, alpha.stds, beta.stds,
     blanks, samples,
     file=str.ana.file)

