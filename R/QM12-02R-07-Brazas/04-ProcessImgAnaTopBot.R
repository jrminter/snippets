# 04-ProcessImgAnaTopBott.R
# source('~/work/proj/QM12-02R-07-Brazas/R/-04ProcessImgAnaTopBott.R')
#
# This script processes a series of .csv files generated by the
# analySIS Imaging-C module 'AnaBseNozzle'. This extracts the
# top and bottom boundary width and plots them as a function
# of nozzle number

rm(list=ls())
library(xtable)

id <- c('qm-03729-1033LTAT-C3-A1',
        'qm-03730-1033LTAT-C3-A2',
        'qm-03731-1033LTAT-C3-C1')

str.wd   <- "~/work/proj/QM12-02R-07B-Brazas/R/"
i.digits <- 3
pdf.dir  <- '../TeX/pdf/'
png.dir  <- '../TeX/png/'
# tab.dir  <- '../TeX/tab/'
# txt.dir  <- '../out/'

# should not need to change below here...
samples <- data.frame(str.id=id)
n.samples <- nrow(samples)



# compute the standard error
stderr <- function(x) sqrt(var(x)/length(x))

# number the nozzles
nozzleNumber <- function(nozzleName, noz.per.seg=512)
{
  nozzle.number <- NA
  lA <- strsplit(nozzleName,"_")
  num.ss <- length(lA[[1]])
  if(num.ss==2)
  {
    seg <- toupper(lA[[1]][1])
    noz <- toupper(lA[[1]][2])
    lB <- strsplit(seg,"S")
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

plot.boundary.width<- function(df)
{
  x.t <- c( min(df$nozzle.number),
            max(df$nozzle.number))
  
  y.t <- c(min(min(df$top), min(df$bot)),
           max(max(df$top), max(df$bot)))
  plot(x.t, y.t, type='n',
       xlab='Nozzle',
       ylab='Boundary Width')
  points(df$nozzle.number,
       df$top, pch=19, col='red',
       main=str.id,
       xlab='Nozzle',
       ylab='Boundary Width')
  points(df$nozzle.number,
         df$bot, pch=19, col='blue')
}

setwd(str.wd)
dir.create(pdf.dir, showWarnings = F, recursive = T)
dir.create(png.dir, showWarnings = F, recursive = T)
#dir.create(tab.dir, showWarnings = F, recursive = T)
#dir.create(txt.dir, showWarnings = F, recursive = T)

for (i in 1:n.samples) {
  str.id   <- samples$str.id[i]
  
  str.sem.file <- paste('../dat/', str.id, '.csv', sep='')
  data <- read.csv(str.sem.file, header=F, skip=1, as.is=T)
  data <- subset(data, data[, 3] > 0 & data[, 4] > 0)
  n.pts <- nrow(data)
  noz.name <- data[, 1]
  nozzle.number <- sapply(noz.name, nozzleNumber)
  num.min <- min(nozzle.number)
  num.max <- max(nozzle.number)
  str.range <- sprintf("%d nozzles within %d-%d", n.pts, num.min, num.max )
  top    <- round(data[, 12], i.digits) # in microns
  bot    <- round(data[, 13], i.digits) # in microns
  df.good <- data.frame(nozzle.number=nozzle.number,
                        top.um=top,
                        bot.um=bot)


  par(mfrow = c(1,1))
  # first for the graphics frame...
  plot.boundary.width(df.good)
  
  

  
  str.pdf <- paste(pdf.dir, str.id,'-bdry.pdf', sep='')
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  plot.boundary.width(df.good)
  dev.off()
  
  str.png <- paste(png.dir, str.id,'-bdry.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.boundary.width(df.good)
  dev.off()

 


}
