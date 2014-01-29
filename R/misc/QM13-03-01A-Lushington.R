### R code from vignette source 'QM13-03-01A'

###################################################
### code chunk number 1: QM13-03-01A.Rnw:94-110
###################################################
# A hidden code chunk
# start with a clean environment
rm(list=ls())
options(digits=4, width=65, continue=" ")
# set as needed
str.home <- Sys.getenv("HOME")
str.wd <- paste(str.home,
                '/work/proj/QM13-03-01A-Lushington/Sweave/',
                sep='')
setwd(str.wd)
Sys.setenv(TEXINPUTS=str.wd)
Sys.setenv(BIBINPUTS=str.wd)
Sys.setenv(BSTINPUTS=str.wd)
# make sure needed packages & functions are loaded
require(xtable)
require(analab)


###################################################
### code chunk number 2: hiddenStats
###################################################
# read the measurements and do some calculations

str.midb <- 'qm-03818'
str.smpl <- 'FNK-6251N'

str.in.file <- paste('../dat/', str.midb, '-',
                     str.smpl, ' - EkParticles.txt', sep='')
dat <- read.table(str.in.file, header=F, sep=',',
                  as.is=TRUE, skip=2)
dat <- subset(dat, dat[,7] > 100) # get rid of undersize
dat[,3] <- 1000*dat[,3] # microns to nm
dat[,4] <- 1000000*dat[,4] # sq.microns to sq.nm
dat[,5] <- 1000*dat[,5] # microns to nm

names(dat) <- c('id','class.id', 'Feret.Min.nm', 'Area.sq.nm', 'ECD.nm',
                'EKRss', 'EKAreaPx','EKRChi2','Elongation','FSD3',
                'FSD4','FSD5', 'FSD6','FSD7','FSD8','FSD.bdry.pts')

ecd <- dat[,5]
rss <- subset(dat[,6], dat[,8] < 100)
n.ecd <- length(ecd)
ecd.med <- median(ecd)
ecd.sd  <- sd(ecd)

n.rss <- length(rss)
rss.med <- median(rss)
rss.sd  <- sd(rss)


###################################################
### code chunk number 3: ECDPlot
###################################################
pin.old <- par()$pin
#           r c          b    l    t    r
par(mfcol=c(1,1), mar=c(5.1, 4.1, 1.1, 3.1))

linear.distn.panel.plot(ecd, n.brks = 50,
                        distn.lab = 'ECD [nm]',
                        hist.legend = TRUE,
                        legend.loc = "topright",
                        kern.bw = "nrd0",
                        plt.median = TRUE,
                        scale.mult = 1.2)
# reset to standard
#           r c          b    l    t    r
par(mfcol=c(1,1), mar=c(5.1, 4.1, 4.1, 2.1))


###################################################
### code chunk number 4: RssPlot
###################################################
pin.old <- par()$pin
#           r c          b    l    t    r
par(mfcol=c(1,1), mar=c(5.1, 4.1, 1.1, 3.1))

linear.distn.panel.plot(rss, n.brks = 50,
                        distn.lab = 'Rss',
                        hist.legend = TRUE,
                        legend.loc = "topright",
                        kern.bw = "nrd0",
                        plt.median = TRUE,
                        scale.mult = 1.2)
# reset to standard
#           r c          b    l    t    r
par(mfcol=c(1,1), mar=c(5.1, 4.1, 4.1, 2.1))


