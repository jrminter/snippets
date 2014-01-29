# 01-ProcessJS.R
# source('~/work/proj/QM12-02R-07-Brazas/R/01-ProcessJS.R')
# This script processes a series of jet straightness data
# files, computing the zero-based nozzle number and retrieving
# the web and array angles for each nozzle. The script constructs
# a data frame and saves it for the chip id. The script also
# generated a stacked plot in both PNG and PDF formats

rm(list=ls())

js.data <- c('PRO_K4-2820.07_01_5_JSR-1_20120807_1057.txt',
             'PRO_K4-2399.12_01_5_JSR-1_20120807_1139.txt')
chip.id <- c('1033LTAT-C2',
             '1033LTAT-C3')
str.wd <- "~/work/proj/QM12-02R-07-Brazas/R/"
pdf.dir <- '../TeX/pdf/'
png.dir <- '../TeX/png/'

# should not need to change below here

samples <- data.frame(str.js=js.data, str.chip=chip.id)
n.samples <- nrow(samples)

nozzleNumberJS <- function(nozzleName)
{
  nozzle.number <- NA
  lA <- strsplit(nozzleName,"_")
  num.ss <- length(lA[[1]])
  if(num.ss==2)
  {
    noz.name <- toupper(lA[[1]][2])
    lB <- strsplit(noz.name,"A")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset  <- 0
      seg.num <- as.numeric(lB[[1]][2])
      nozzle.number <- offset + seg.num
    }
    
    lB <- strsplit(noz.name,"B")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset  <- 512
      seg.num <- as.numeric(lB[[1]][2])
      nozzle.number <- offset + seg.num
    }
    
    lB <- strsplit(noz.name,"C")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset  <- 2*512
      seg.num <- as.numeric(lB[[1]][2])
      nozzle.number <- offset + seg.num
    }    

    lB <- strsplit(noz.name,"D")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset  <- 3*512
      seg.num <- as.numeric(lB[[1]][2])
      nozzle.number <- offset + seg.num
    }
    
    lB <- strsplit(noz.name,"E")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset  <- 4*512
      seg.num <- as.numeric(lB[[1]][2])
      nozzle.number <- offset + seg.num
    }
  } 
  nozzle.number
}

plot.js <- function(df, chip)
{
  par(mfrow = c(2,1))
  oldpar <- par(mar=c(0.0,4.1,2.1,1.1))
  plot(df$nozzle.number,
       df$web.angle, pch=46, col='red',
       main=chip, axes=F,
       xlab='Nozzle',
       ylab='JS Web Angle')
  axis(2)
  box()
  par(mar=c(3.1,4.1,0,1.1))
  plot(df$nozzle.number,
       df$array.angle, pch=46, col='black',
       xlab='Nozzle',
       ylab='JS Array Angle')
  mtext('Nozzle', side=1, line=2)
  par(mfrow = c(1,1))
  par(oldpar)
}

setwd(str.wd)
dir.create(pdf.dir, showWarnings = F, recursive = T)
dir.create(png.dir, showWarnings = F, recursive = T)

for (i in 1:n.samples) {
  str.id <- samples$str.chip[i]
  str.js.data <- samples$str.js[i]
  
  str.file <- paste('../dat/', str.js.data, sep='')
  data <- read.table(str.file, header=T, as.is=T, skip=3)
  web.angle <- data$Web_Angle
  names(web.angle) <- NULL
  array.angle <- data$Array_Angle
  names(array.angle) <- NULL
  jet.id <- data$Jet_ID
  
  # print(head(jet.id))
  nozzle.number <- sapply(jet.id, nozzleNumberJS)
  names(nozzle.number) <- NULL
  
  js <- data.frame(nozzle.number=nozzle.number, web.angle=web.angle, array.angle=array.angle)
  
  str.rd <- paste('../dat/', str.id, '-JS.RData', sep='')
  
  # print(head(js))
  plot.js(js, str.id)
  
  save(js, file=str.rd)
  
  
  str.pdf <- paste(pdf.dir, str.id,'-js-full.pdf', sep='')
  
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  plot.js(js, str.id)
  dev.off()
  
  str.png <- paste(png.dir, str.id,'-js-full.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.js(js, str.id)
  dev.off()
}



