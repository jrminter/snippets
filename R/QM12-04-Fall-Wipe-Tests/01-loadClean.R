# 01-loadClean.R
# 
# Retrieve sample id, acquistion date/time, and raw count data
# from the Eclipse access data base for each sample in an ensemble
# of input analysis batches. Convert the data from cts/sec to cts/min
# and create an R data frame containing:
# batch, id, acq.date, alpha.cpm, alpha.se, beta.cpm, beta.se
# for each sample analyzed. Use dput to store this data frame as an 
# R object in the project data directory using the analysis job name
# with a file extension '-raw.R' for subsequent processing.
#
# We also create and store a data environment in the project data directory
# using "save" with the name 'wipeTest.RData'. At this point, we will just
# save the analysis name. Later processing will store other 
# information needed so information need be entered only once (the DRY
# principle...)
#
#        Author: J. R. Minter
# Creation Date: 05-Nov-12
# Modified:
#   Date     By   Comment
# 05-Nov-12  JRM  Initial release for Fall 2012 

rm(list=ls())
require(RODBC)

str.wd  <- '~/work/proj/QM12-04-Fall/R/'
str.ana <- 'QM12-04-Fall'
# we will always assume this convention so don't need to store it...
dat.dir <- '../dat/' 
bDebug  <- F

batches <- c("2790", "2793", "2808","2811","2814","2818","2821",
             "2824","2827", "2830","2833")

setwd(str.wd)

#
# should not need to change below here
#
dir.create(dat.dir, showWarnings = F, recursive = T)
str.ana.file <- paste(dat.dir,'wipeTest.RData')


str.sql.one   <- "SELECT [Sample Aliquots].[Batch Key], [Sample Aliquots].[Aliquot Sample Key]," 
str.sql.two   <- "[Sample Aliquots].[Creation Time], [Sample Aliquots].[Alias ID]"
str.sql.three <- "FROM [Sample Aliquots] WHERE [Sample Aliquots].[Batch Key]="

queryCounts <- function(df, j, chan=ch){
  the.id  <- as.character(df$alias.id[j])
  the.ask <- as.character(df$aliquot.sample.key[j])
  str.sql.acq.one <- " Select * FROM [LB Acquistion Data] where [Aliquot Sample Key] = "
  str.sql.acq  <- paste(str.sql.acq.one,the.ask,sep="")
  # print(str.sql.acq)
  dat <- sqlQuery(chan, str.sql.acq)
  dat
}
nBatch <- length(batches)
ch <- odbcConnect("Eclipse")
raw.data <- NULL
for ( i in  1:nBatch) {
  str.sql <- paste(str.sql.one, str.sql.two, str.sql.three,
                   batches[i], sep=" ")
  sql.dat <- sqlQuery(ch, str.sql)
  names(sql.dat) <- c("batch.key","aliquot.sample.key","creation.time",
                      "alias.id")
  dat.cts <- NULL
  nRows = nrow(sql.dat)
  for(j in 1:nRows){
    cts <- queryCounts(sql.dat, j)
    dat.cts <- rbind(dat.cts, cts)
  }
  sql.dat <- cbind(sql.dat, dat.cts)
  raw.data <- rbind(raw.data, sql.dat)
  if(!bDebug) rm(cts, dat.cts, sql.dat)  
}
close(ch)
# to.rm <- c(2,3,5,6,7,9,14,15,16,17,18,20,21,22,23,24,25,26,27,28)
to.rm <- c(2,3,5,6,7,9,14:28)

if(!bDebug) print(names(raw.data))
# print(head(raw.data))
raw.data <- raw.data[,-to.rm]
if(!bDebug)  print(names(raw.data))
if(!bDebug)  print(head(raw.data))
raw.data[,4] <- 60*raw.data[,4] # convert from cps to cpm
raw.data[,5] <- 60*raw.data[,5]
raw.data[,6] <- 60*raw.data[,6]
raw.data[,7] <- 60*raw.data[,7]

names(raw.data) <- c('batch', 'id', 'acq.date',
                     'alpha.cpm', 'alpha.se',
                     'beta.cpm', 'beta.se') 
# ,
# 'live.sec')
print(head(raw.data))

str.file <- paste(dat.dir, str.ana, '-raw.R', sep='')
dput(raw.data, str.file)

save( str.ana, file=str.ana.file)


