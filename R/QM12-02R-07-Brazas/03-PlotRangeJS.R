# 03-PlotRangeJS.R
# Plot a range of jet straightness values cooresponding
# to a region of interest of a nozzle
#
# source('~/work/proj/QM12-02R-07-Brazas/R/03-PlotRangeJS.R')
rm(list=ls())


str.wd  <- "~/work/proj/QM12-02R-07-Brazas/R/"
pdf.dir <- '../TeX/pdf/'
png.dir <- '../TeX/png/'

# create a vector of the chips for the desired region
v.chip <- c('1033LTAT-C2',
            '1033LTAT-C2',
			'1033LTAT-C3',
			'1033LTAT-C3',
			'1033LTAT-C3')
v.min <- c(  75,
           1274,
             50,
            290,
          1274)
v.max <-  c( 110,
            1315,
             100,
             330,
            1304)

# should not need to change below here...
# create a data frame of ROIS

df.roi <- data.frame(chip.id=v.chip, noz.min=v.min, noz.max=v.max)
n.samples <- nrow(df.roi)

plot.js.range <- function(df, chip){
  par(mfrow = c(2,1))
  oldpar <- par(mar=c(0.0,4.1,2.1,1.1))
  plot(df$nozzle.number,
       df$web.angle, pch=19, col='red',
       main=chip, axes=F,
       xlab='Nozzle',
       ylab='JS Web Angle')
  axis(2)
  box()
  par(mar=c(3.1,4.1,0,1.1))
  plot(df$nozzle.number,
       df$array.angle, pch=19, col='black',
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
  str.chip <- df.roi$chip.id[i]
  noz.min  <- df.roi$noz.min[i]
  noz.max  <- df.roi$noz.max[i]
  
  str.js <- paste('../dat/', str.chip, '-JS.RData', sep='')
  load(str.js)
  str.roi <- sprintf('%s-N%dto%d', str.chip, noz.min, noz.max)
  
  js <- subset(js, js$nozzle.number >= noz.min & js$nozzle.number <= noz.max)
  
  # first time for the graphics window...
  plot.js.range(js, chip=str.roi)
  
  # now for the PDF
  str.pdf <- paste('../TeX/png/', str.roi,'-js.pdf', sep='')
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  plot.js.range(js, chip=str.roi)
  dev.off()
  
  # now for the png
  str.png <- paste('../TeX/png/', str.roi,'-js.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.js.range(js, chip=str.roi)
  dev.off()
 
 }
