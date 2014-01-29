# 01-calibMag.R
rm(list=ls())
library(xtable)

# str.wd <- "~/work/R/gm-02/R/"
str.wd <- "~/work/qm12-02d-02/R/R/"
str.id <- 'Sirion-5kV-uhr-5mm_15000'
str.caption <- paste('Magnification calibration of the Sirion',
                     'ADDA interface at 5 kV and 15,000X in',
                     'in UHR mode')
str.label <- 'tab:magCal'
str.align <- '|l|r|r|r|'
n.digits <- 4

# should not need to change below here...
stderr <- function(x) sqrt(var(x)/length(x))

setwd(str.wd)
str.file <- paste('../dat/sem/mag/', str.id, '_kmag.csv', sep='')
data <- read.csv(str.file, header = TRUE)
x <- data$x
y <- data$y

x.avg <- mean(x)
x.se  <- stderr(x)

y.avg <- mean(y)
y.se  <- stderr(y)

ar.avg <- x.avg/y.avg
# add the uncertainties in quadrature
ar.se  <- ar.avg*sqrt((x.se/x.avg)^2 + (y.se/y.avg)^2) 

means <- round(c(x.avg, y.avg, ar.avg), n.digits)
se    <- round(c(x.se,  y.se,  ar.se),  n.digits)
n.obs <- c(length(x),length(y), NA)
df <- data.frame(avg=means, std.err=se, n.obs=n.obs)
rownames(df) <- c('X (scan)','Y (frame)','Aspect Ratio')

xt.dig <- c(n.digits, n.digits, n.digits, 1)
xt <- xtable(df, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

str.cal <- '../../TeX/methods/cal-table.tex'
sink(str.cal)

print(xt)

sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.cal, sep='\n', append=T)


