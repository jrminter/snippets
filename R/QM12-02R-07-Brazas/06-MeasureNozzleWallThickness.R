# 06-MeasureNozzleWallThickness.R
# Measure and plot the top and bottom wall thickness
# for a chip

rm(list=ls())

str.wd   <- '~/work/proj/QM12-02R-07B-Brazas/R/'
str.chip <- 'qm-03729-1033LTAT-C3-A1'
str.pre  <- 'SA_'

pdf.dir <- '../TeX/pdf/'
png.dir <- '../TeX/png/'

# number the nozzles
get.noz <- function(x)
{
  lA <- strsplit(x,"_")
  lB <- strsplit(lA[[1]][2],'-') 
  lB[[1]][1]
}

plot.profiles<- function(df)
{
  oldpar <- par()
  par(mfrow = c(1,1))
  x.t <- c(4.6, 5.4)
  y.t <- c(0, 3600)
  plot(x.t, y.t, type='n',
       xlab='radius [um]',
       ylab='gray level',
       main=paste(str.chip, str.noz))
  
  points(df$radius, df$bottom,
         pch=19, col='blue')
  points(df$radius, df$top,
         pch=19, col='red')
  legend(5.25, 800,
         c('bottom','top'),
         col=c('blue', 'red'),
         pch=c(19,19))
  par(oldpar)
  
}

setwd(str.wd)

str.data.dir <- '../dat/prof/'
str.files.dir <- paste(str.data.dir,
                       str.chip, sep='')
f.l <- list.files(path = str.files.dir)
nz <- unlist(lapply(f.l, get.noz))

n.noz <- length(nz)
for (i in 1:n.noz){
  str.noz <- nz[i]
  str.file <- paste(str.data.dir,
                    str.chip,'/',
                    str.chip, '-',str.pre,str.noz,
                    '-prof.csv', sep='')
  data <- read.csv(str.file, header=T, as.is=T)
  
  dir.create(pdf.dir, showWarnings = F, recursive = T)
  dir.create(png.dir, showWarnings = F, recursive = T)
  
  plot.profiles(data)
  
  str.id <- paste(str.chip, '-',str.noz,sep='')
  
  str.pdf <- paste(pdf.dir, str.id,'-prof.pdf', sep='')
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  plot.profiles(data)
  dev.off()
  
  str.png <- paste(png.dir, str.id,'-prof.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.profiles(data)
  dev.off()
}
