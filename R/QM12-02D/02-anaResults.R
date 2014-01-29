# 02-anaResults.R

rm(list=ls())
library(xtable)

str.id <- 'FY26H-09-01'
# str.mode <- 'raw'
str.mode <- 'ellipse'
str.wd <- "~/work/qm12-02d-02/R/R/"
i.digits <- 4
# png dimentions
png.w=800
png.h=600



# should not need to change below here...
# set up functions
# compute the standard error
stderr <- function(x) sqrt(var(x)/length(x))

# plot and analyze the results from segment 0....n
plotSegment <- function( df,                # dataframe
                         chip.id,           # chip number
                         str.seg,           # seg ID A,...
                         str.mode,          # mode (raw, ellipse)
                         noz.per.seg=512,   #
                         do.title=TRUE,     # print a title
                         legend.offset.x=0, # offset from center 
                         legend.offset.y=0) # of the legend
{
  nLo <- -1
  nHi  <- -1
  df.seg <- NA
  if(str.seg=='A')
  {
    nLo <- 0
    nHi <- noz.per.seg
  }
  if(str.seg=='B')
  {
    nLo <- noz.per.seg
    nHi <- 2*noz.per.seg-1
  }
  if(str.seg=='C')
  {
    nLo <- 2*noz.per.seg
    nHi <- 3*noz.per.seg-1
  }
  if(str.seg=='D')
  {
    nLo <- 3*noz.per.seg
    nHi <- 4*noz.per.seg-1
  }
  if(str.seg=='E')
  {
    nLo <- 4*noz.per.seg
    nHi <- 5*noz.per.seg-1
  }
  if(nLo > -1)
  {
      x   <- df$nozzle.number[df$nozzle.number >= nLo]
    aif   <- df$aif.dia.inner[df$nozzle.number >= nLo]
    sem   <- df$sem.dia.inner[df$nozzle.number >= nLo]
    delta <- df$delta[df$nozzle.number >= nLo]
    df.t <- data.frame(nozzle.number=x,
                       aif.dia.inner=aif,
                       sem.dia.inner=sem,
                       delta=delta)
    x     <- df.t$nozzle.number[df.t$nozzle.number < nHi]
    aif   <- df.t$aif.dia.inner[df.t$nozzle.number < nHi]
    sem   <- df.t$sem.dia.inner[df.t$nozzle.number < nHi]
    delta <- df.t$delta[df.t$nozzle.number < nHi]
    
    x.t <- c(min(x), max(x))
    y.t <- c(min(min(aif), min(sem)),
             max(max(aif), max(sem)))
    str.title=paste('Segment', str.seg, 'from chip', chip.id,
                    'with', str.mode, 'boundaries')
    if(do.title)
    {
      plot(x.t, y.t, type='n', xlab='nozzle number',
           ylab='diameter', main=str.title)
    }
    else
    {
      plot(x.t, y.t, type='n', xlab='nozzle number',
           ylab='diameter')   
    }
    p.c.x <- mean(x.t)
    p.c.y <- mean(y.t)
    points(x, aif, pch=17, col='red')
    points(x, sem, pch=19, col='blue')
    legend(p.c.x + legend.offset.x,
           p.c.y + legend.offset.y,
           legend =c('AIF', 'SEM'),
           col=c('red', 'blue'),
           pch=c(17, 19) )
    sem.avg   <- mean(sem)
    sem.se    <- stderr(sem)
    aif.avg   <- mean(aif)
    aif.se    <- stderr(aif)
    delta.avg <- mean(delta)
    delta.se  <- stderr(delta)
    avg <- c(sem.avg, aif.avg, delta.avg)
    se  <- c(sem.se,  aif.se,  delta.se)
    df.seg <- data.frame(avg=avg, se=se)
    rownames(df.seg) <- c('SEM', 'AIF', 'Delta')
    # return the segment statistics
    df.seg <- round(df.seg, i.digits)
    df.seg
  }

  
}

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
str.file <- paste('../dat/sem/', str.mode,'/', str.id, '.csv', sep='')
data <- read.csv(str.file, header = TRUE, as.is=T)
noz.name <- data[, 1]
sem.dia.inner <- round(data[, 3], i.digits)
sem.dia.outer <- round(data[, 4], i.digits)

the.name <- noz.name[1]

nozzle.number <- sapply(noz.name, nozzleNumber)

df <- data.frame(chip=str.id,
                 nozzle.number=nozzle.number,
                 sem.dia.inner=sem.dia.inner,
                 sem.dia.outer=sem.dia.outer,
                 aif.dia.inner=0)
rownames(df) <- NULL

rm(data)

str.file <- paste('../dat/aif-sys1/', str.id, '.txt', sep='')
data <- read.csv(str.file, header=F, as.is=T)

# now get the aif
for(i in 1:nrow(df))
{  
  nn <- df$nozzle.number[i]
  # n.b. row numbers are 1 based, nozzle numbers are 0 based...
  aif <- data[nn+1, 1]
  df$aif.dia.inner[i] <- aif
}

df$delta <- df$aif.dia.inner - df$sem.dia.inner

print(tail(df))

print(summary(df$delta))

statsA <- plotSegment(df, str.id, 'A', str.mode, noz.per.seg=512,
                      do.title=T,
                      legend.offset.x=0,
                      legend.offset.y=0)

# Create the plot with a larger point size
str.png <- paste('../../TeX/png/',str.id,'-SegA-',
                 str.mode, '.png', sep='')
png(str.png, pointsize=24, width=png.w, height=png.h)
statsA <- plotSegment(df, str.id, 'A', str.mode, noz.per.seg=512,
                      do.title=F,
                      legend.offset.x=0,
                      legend.offset.y=0)
dev.off()

str.tex <- paste('../../TeX/methods/',str.id,'-SegA-',
                 str.mode, '.tex', sep='')
str.label <- paste('tab:ana',str.id,'A-',str.mode ,sep='')
str.align <- '|r|r|r|'
str.caption <- paste('Analysis of', str.id, 'Segment A', 
                     'with', str.mode, 'boundaries')
xt.dig <- c( i.digits,  i.digits, i.digits)
xt <- xtable(statsA, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)

statsE <- plotSegment(df, str.id, 'E', str.mode, noz.per.seg=512,
                      do.title=T,
                      legend.offset.x=0,
                      legend.offset.y=0)

# Create the plot with a larger point size
str.png <- paste('../../TeX/png/',str.id,'-SegE-',
                 str.mode, '.png', sep='')
png(str.png, pointsize=24, width=png.w, height=png.h)
statsE <- plotSegment(df, str.id, 'E', str.mode, noz.per.seg=512,
                      do.title=F,
                      legend.offset.x=0,
                      legend.offset.y=0)
dev.off()

str.tex <- paste('../../TeX/methods/',str.id,'-SegE-',
                 str.mode, '.tex', sep='')
str.label <- paste('tab:ana',str.id,'E-',str.mode ,sep='')
str.align <- '|r|r|r|'
str.caption <- paste('Analysis of', str.id, 'Segment E', 
                     'with', str.mode, 'boundaries')
xt.dig <- c( i.digits,  i.digits, i.digits)
xt <- xtable(statsE, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)


