# svgPlot.R
# Creating SVG Plots from R
# based on
# http://www.paulhurley.co.uk/index.php/categories/computing-geek/27-r-stats/78-creating-svg-plots-from-r
# jrm replaced ggplot2 graphics with standard. Had trouble with
# ggplot in function
rm(list=ls())
str.wd <- '~/Dropbox/work/_R/'
setwd(str.wd)
library(ggplot2)
library(Cairo)
dataframe <- data.frame(fac = factor(c(1:4)),
                        data1 = rnorm(400, 100, sd = 15))
dataframe$data2 <- dataframe$data1 * c(0.25, 0.5, 0.75, 1)
testplot <- function(){
  boxplot(data2~fac,data=dataframe, pch=19, cex=.4,
          col=c('red', 'blue', 'slateblue','green'),
          xlab='factor', ylab='data', main='boxplot')
  legend('topleft',
         legend=c('fac1', 'fac2', 'fac3', 'fac4'),
         pch=c(15,15,15,15),
         col=c('red', 'blue', 'slateblue','green'))
  stripchart(data2~fac,data=dataframe,
             method="jitter",jitter=.075,
             pch=19, cex=.4,
             # col=c('red', 'blue', 'slateblue','green'),
             vertical=T,add=T)
}
testplot()
# Produce a PNG plot

Cairo(800, 800,
      file = "testplot12200.png",
      type = "png", bg = "transparent",
      pointsize = 12, units = "px", dpi = 200)
testplot()
dev.off()
#Produce an svg file
Cairo(800,800,
      file="cairo_2.svg",
      type="svg",
      bg="transparent",
      pointsize=12,
      units="in",dpi=400,
      width=20, height=20)
testplot()
dev.off()

