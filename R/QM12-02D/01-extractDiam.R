# 01-extractDiam.R
# extract ID and OD and number nozzle fom analySIS .csv file
# make a simple data frame and write a .csv

rm(list=ls())

str.id <- '1033LTAT-12-06'
str.wd <- "~/work/R/extractDiam/R/"
i.digits <- 4




# should not need to change below here...
# set up functions

nozzleNumber <- function(nozzleName, noz.per.seg=512)
{
  nozzle.number <- NA
  lA <- strsplit(nozzleName,"_")
  num.ss <- length(lA[[1]])
  if(num.ss==2)
  {
    seg <- toupper(lA[[1]][1])
    noz <- toupper(lA[[1]][2])
    lB <- strsplit(seg,"SEG")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset <- -1
      seg.name <- (lB[[1]][2])
      if(seg.name=='A') offset=0
      if(seg.name=='B') offset=noz.per.seg
      if(seg.name=='C') offset=2*noz.per.seg
      if(seg.name=='D') offset=3*noz.per.seg
      if(seg.name=='E') offset=4*noz.per.seg
      if(offset > -1)
      {
        lC <- strsplit(noz,"N")
        num.ssc <- length(lC[[1]])
        if(num.ssc==2)
        {
          noz.num.in.seg <- as.numeric(lC[[1]][2])
          # numbers are zero based
          nozzle.number <- offset + noz.num.in.seg
        }
      }
    }
  } 
  nozzle.number
}

setwd(str.wd)
str.file <- paste('../dat/', str.id, '.csv', sep='')
data <- read.csv(str.file, header = TRUE, as.is=T)
noz.name <- data[, 1]
sem.dia.inner <- round(data[, 3], i.digits)
sem.dia.outer <- round(data[, 4], i.digits)

the.name <- noz.name[1]

nozzle.number <- sapply(noz.name, nozzleNumber)

df <- data.frame( nozzleNum=nozzle.number,
                  ID=sem.dia.inner,
                  OD=sem.dia.outer)
rownames(df) <- NULL

str.out <- paste('../out/',str.id,'.csv', sep='')

write.csv(df,file=str.out, row.names=F)

