### R code from vignette source 'QM13-02-01A'

###################################################
### code chunk number 1: QM13-02-01A.Rnw:87-116
###################################################
# A hidden code chunk
# start with a clean environment
rm(list=ls())
options(digits=4, width=65, continue=" ")
# set as needed
str.home <- Sys.getenv("HOME")
str.wd <- paste(str.home,
                '/work/proj/QM13-02-01A-Shukla/Sweave/', sep='')
setwd(str.wd)
Sys.setenv(TEXINPUTS=str.wd)
Sys.setenv(BIBINPUTS=str.wd)
Sys.setenv(BSTINPUTS=str.wd)
# make sure needed packages & functions are loaded
require(xtable)
require(analab)
# load the data and compute basic summary stats
str.len.file <- '../dat/meas/length.txt'
str.wid.file <- '../dat/meas/width.txt'
len <- read.table(str.len.file, as.is=TRUE, skip=3, sep=',')
len <- round(len[,3],1)
len.med <- round(median(len), 1)
len.sd  <- round(sd(len), 1)
len.ct  <- length(len)

wid <- read.table(str.wid.file, as.is=TRUE, skip=3, sep=',')
wid <- round(wid[,3],1)
wid.med <- round(median(wid), 1)
wid.sd  <- round(sd(wid), 1)
wid.ct  <- length(wid)


###################################################
### code chunk number 2: hiddenLengthPlot
###################################################
# hidden code to produce a plot
linear.distn.panel.plot(len, n.brks = 5,
                        distn.lab = 'length [nm]',
                        hist.legend = TRUE,
                        legend.loc = "topright",
                        kern.bw = sd(len), plt.median = TRUE,
                        scale.mult = 1.2)


###################################################
### code chunk number 3: LengthPlot
###################################################
# hidden code to produce a plot
linear.distn.panel.plot(len, n.brks = 5,
                        distn.lab = 'length [nm]',
                        hist.legend = TRUE,
                        legend.loc = "topright",
                        kern.bw = sd(len), plt.median = TRUE,
                        scale.mult = 1.2)


###################################################
### code chunk number 4: hiddenWidthPlot
###################################################
# hidden code to produce a plot
linear.distn.panel.plot(wid, n.brks = 5,
                        distn.lab = 'width [nm]',
                        hist.legend = TRUE,
                        legend.loc = "topright",
                        kern.bw = sd(wid), plt.median = TRUE,
                        scale.mult = 1.2)


###################################################
### code chunk number 5: WidthPlot
###################################################
# hidden code to produce a plot
linear.distn.panel.plot(wid, n.brks = 5,
                        distn.lab = 'width [nm]',
                        hist.legend = TRUE,
                        legend.loc = "topright",
                        kern.bw = sd(wid), plt.median = TRUE,
                        scale.mult = 1.2)


