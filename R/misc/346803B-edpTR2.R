### R code from vignette source '346803B-edpTR2'

###################################################
### code chunk number 1: 346803B-edpTR2.Rnw:118-137
###################################################
# A hidden code chunk
# start with a clean environment
rm(list=ls())
options(digits=4, width=65, continue=" ")
# set as needed
# set as needed
str.home <- Sys.getenv("HOME")
str.wd <- paste(str.home,
                '/work/proj/346803B-edpTR2/Sweave/',
                sep='')
setwd(str.wd)
Sys.setenv(TEXINPUTS=str.wd)
Sys.setenv(BIBINPUTS=str.wd)
Sys.setenv(BSTINPUTS=str.wd)
# make sure needed packages & functions are loaded
require(xtable)
require(edp)
icdd.dir <- '../../../global/lines/'



###################################################
### code chunk number 2: hiddenAlBkgTunePlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03801-Al-01'
r.start  <- 210
r.end    <- 1200
bkg.ord  <- '4'
bkg.win  <- '15'

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

# do the work
al.pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                                edp.base=str.bas,
                                r.min=r.start,
                                r.max=r.end,
                                sb.win=bkg.win,
                                sb.ord=bkg.ord )


###################################################
### code chunk number 3: AlBkgTunePlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03801-Al-01'
r.start  <- 210
r.end    <- 1200
bkg.ord  <- '4'
bkg.win  <- '15'

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

# do the work
al.pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                                edp.base=str.bas,
                                r.min=r.start,
                                r.max=r.end,
                                sb.win=bkg.win,
                                sb.ord=bkg.ord )


###################################################
### code chunk number 4: hiddenNiOBkgTunePlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03800-NiO-01'
r.start  <- 210
r.end    <- 1100
bkg.ord  <- '2'
bkg.win  <- '15'

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

# do the work
ni.o.pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                                  edp.base=str.bas,
                                  r.min=r.start,
                                  r.max=r.end,
                                  sb.win=bkg.win,
                                  sb.ord=bkg.ord )


###################################################
### code chunk number 5: NiOBkgTunePlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03800-NiO-01'
r.start  <- 210
r.end    <- 1100
bkg.ord  <- '2'
bkg.win  <- '15'

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

# do the work
ni.o.pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                                  edp.base=str.bas,
                                  r.min=r.start,
                                  r.max=r.end,
                                  sb.win=bkg.win,
                                  sb.ord=bkg.ord )


###################################################
### code chunk number 6: hiddenBaTiO3BkgTunePlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03797-53C'
r.start  <- 210
r.end    <- 1000
bkg.ord  <- '6'
bkg.win  <- '15'

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

# do the work
ba.ti.o3.pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                                      edp.base=str.bas,
                                      r.min=r.start,
                                      r.max=r.end,
                                      sb.win=bkg.win,
                                      sb.ord=bkg.ord )


###################################################
### code chunk number 7: BaTiO3BkgTunePlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03797-53C'
r.start  <- 210
r.end    <- 1000
bkg.ord  <- '6'
bkg.win  <- '15'

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

# do the work
ba.ti.o3.pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                                      edp.base=str.bas,
                                      r.min=r.start,
                                      r.max=r.end,
                                      sb.win=bkg.win,
                                      sb.ord=bkg.ord )


###################################################
### code chunk number 8: hiddenAlCamConstPlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03801-Al-01'
r.start     <- 255
r.end       <- 750
bkg.ord     <- '4'
bkg.win     <- '15'
kV          <- 200
cl.mm       <- 340
bin         <-   1
card.no     <- '04-0787'
cmpd.name   <- 'Al'
space.group <- 'Fm3m'
pk.sig      <- 4.0
pk.thr      <- 0.8
pk.hw       <- 4

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

al.cam.const <- meas.camera.constant(cnt.dir=dat.dir,
                                     cnt.base=str.bas,
                                     r.start,
                                     r.end,
                                     sb.win=bkg.win,
                                     sb.ord=bkg.ord,
                                     hw.hm=4,
                                     icdd.dir=icdd.dir,
                                     icdd.no=card.no,
                                     compound=cmpd.name,
                                     sp.grp=space.group,
                                     pk.sigma=pk.sig,
                                     pk.thres=pk.thr,
                                     ccd.px.mm=15,
                                     do.log.y=FALSE,
                                     main=NA)


###################################################
### code chunk number 9: AlCamConstPlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03801-Al-01'
r.start     <- 255
r.end       <- 750
bkg.ord     <- '4'
bkg.win     <- '15'
kV          <- 200
cl.mm       <- 340
bin         <-   1
card.no     <- '04-0787'
cmpd.name   <- 'Al'
space.group <- 'Fm3m'
pk.sig      <- 4.0
pk.thr      <- 0.8
pk.hw       <- 4

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

al.cam.const <- meas.camera.constant(cnt.dir=dat.dir,
                                     cnt.base=str.bas,
                                     r.start,
                                     r.end,
                                     sb.win=bkg.win,
                                     sb.ord=bkg.ord,
                                     hw.hm=4,
                                     icdd.dir=icdd.dir,
                                     icdd.no=card.no,
                                     compound=cmpd.name,
                                     sp.grp=space.group,
                                     pk.sigma=pk.sig,
                                     pk.thres=pk.thr,
                                     ccd.px.mm=15,
                                     do.log.y=FALSE,
                                     main=NA)


###################################################
### code chunk number 10: hiddenNiOCamConstPlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03800-NiO-01'
r.start     <- 255
r.end       <- 750
bkg.ord     <- '2'
bkg.win     <- '15'
kV          <- 200
cl.mm       <- 340
bin         <-   1
card.no     <- '47-1049'
cmpd.name   <- 'NiO'
space.group <- 'Fm3m'
pk.sig      <- 7.0
pk.thr      <- 5.0
pk.hw       <- 10

ni.o.cam.const <- meas.camera.constant(cnt.dir=dat.dir,
                                       cnt.base=str.bas,
                                       r.start,
                                       r.end,
                                       sb.win=bkg.win,
                                       sb.ord=bkg.ord,
                                       hw.hm=4,
                                       icdd.dir=icdd.dir,
                                       icdd.no=card.no,
                                       compound=cmpd.name,
                                       sp.grp=space.group,
                                       pk.sigma=pk.sig,
                                       pk.thres=pk.thr,
                                       ccd.px.mm=15,
                                       do.log.y=FALSE,
                                       main=NA)


###################################################
### code chunk number 11: NiOCamConstPlot
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03800-NiO-01'
r.start     <- 255
r.end       <- 750
bkg.ord     <- '2'
bkg.win     <- '15'
kV          <- 200
cl.mm       <- 340
bin         <-   1
card.no     <- '47-1049'
cmpd.name   <- 'NiO'
space.group <- 'Fm3m'
pk.sig      <- 7.0
pk.thr      <- 5.0
pk.hw       <- 10

ni.o.cam.const <- meas.camera.constant(cnt.dir=dat.dir,
                                       cnt.base=str.bas,
                                       r.start,
                                       r.end,
                                       sb.win=bkg.win,
                                       sb.ord=bkg.ord,
                                       hw.hm=4,
                                       icdd.dir=icdd.dir,
                                       icdd.no=card.no,
                                       compound=cmpd.name,
                                       sp.grp=space.group,
                                       pk.sigma=pk.sig,
                                       pk.thres=pk.thr,
                                       ccd.px.mm=15,
                                       do.log.y=FALSE,
                                       main=NA)


###################################################
### code chunk number 12: hiddenDelta
###################################################
# hidden code
cc.avg  <- 0.5*(ni.o.cam.const[1]+al.cam.const[1])
cc.dif  <- abs(ni.o.cam.const[1]-al.cam.const[1])
rel.dif <- 100*cc.dif/cc.avg


###################################################
### code chunk number 13: hiddenNiOold
###################################################
# hidden code to do the plot

dat.dir  <- '../dat/rad/'
str.bas  <- 'qm-03800-NiO-01'
r.start     <- 255
r.end       <- 750
bkg.ord     <- '2'
bkg.win     <- '15'
kV          <- 200
cl.mm       <- 340
bin         <-   1
card.no     <- '04-0835'
cmpd.name   <- 'NiO'
space.group <- 'Fm3m'
pk.sig      <- 7.0
pk.thr      <- 5.0
pk.hw       <- 10

dir.create(dat.dir, showWarnings = FALSE, recursive = TRUE)

str.file <- paste(dat.dir, str.bas,
                  '-dc-ra.csv', sep='')
ni.o.old.cam.const <- meas.camera.constant(cnt.dir=dat.dir,
                                           cnt.base=str.bas,
                                           r.start,
                                           r.end,
                                           sb.win=bkg.win,
                                           sb.ord=bkg.ord,
                                           hw.hm=4,
                                           icdd.dir=icdd.dir,
                                           icdd.no=card.no,
                                           compound=cmpd.name,
                                           sp.grp=space.group,
                                           pk.sigma=pk.sig,
                                           pk.thres=pk.thr,
                                           ccd.px.mm=15,
                                           do.log.y=FALSE,
                                           main=NA)


###################################################
### code chunk number 14: hiddenDelta
###################################################
# hidden code
cc.avg.ni.o   <- 0.5*(ni.o.cam.const[1]+ni.o.old.cam.const[1])
cc.dif.ni.o   <-  abs(ni.o.cam.const[1]-ni.o.old.cam.const[1])
rel.dif.ni.o  <- 100*cc.dif.ni.o/cc.avg.ni.o


###################################################
### code chunk number 15: hiddenAna912L
###################################################
# analyze 912L ZnO
dat.dir  <- '../dat/rad/'
icdd.dir <- '../../../global/lines/'
zno.al.r.min  <- 270
zno.al.r.max  <- 800
zno.al.bk.win <- '15'
zno.al.bk.ord <- '6'
zno.al.hw.hm  <- 4
zno.al.pk.sigma <- 5.0
zno.al.pk.thres <- 2.0

n.samp <- 3
# first measure the camera length
v.cc.mu <- vector('numeric', n.samp)
v.cc.se <- vector('numeric', n.samp)
for(i in 1:n.samp){
  base.str <- paste('912L',i,'-Al', sep='')
  cc <- meas.camera.constant(cnt.dir=dat.dir, cnt.base=base.str,
                             r.min=zno.al.r.min, r.max=zno.al.r.max,
                             sb.win=zno.al.bk.win,sb.ord =zno.al.bk.ord,
                             hw.hm=zno.al.hw.hm,
                             icdd.dir=icdd.dir, icdd.no = '04-0787',
                             compound='Al', sp.grp='Fm3m',
                             pk.sigma=zno.al.pk.sigma,
                             pk.thres=zno.al.pk.thres,
                             ccd.px.mm=15, do.plot=FALSE, do.log.y=FALSE)
  v.cc.mu[i] <- cc[1]
  v.cc.se[i] <- cc[2]
}
df.cc <- data.frame(cc.mu.px.A=v.cc.mu, cc.se.px.A=v.cc.se)
m23   <- 0.5*(df.cc[2,1]+df.cc[3,1])
fudge <- m23/df.cc[1,1]

zno.r.min       <-  255
zno.r.max       <-  750
zno.bk.win      <- '15'
zno.bk.ord      <- '4'
zno.sig         <- 5.0
zno.thr         <- 2.0

str.file  <- '912L1-np'

df.912L1  <- process.edp.dm(dat.path=dat.dir,
                            edp.base=str.file,
                            r.min=zno.r.min,
                            r.max=zno.r.max,
                            sb.win=zno.bk.win,
                            sb.ord=zno.bk.ord,
                            cc.mu.px.A=df.cc[1,1],
                            do.plot=FALSE,
                            do.log=FALSE)
df.912L1.f <- process.edp.dm(dat.path=dat.dir,
                             edp.base=str.file,
                             r.min=zno.r.min,
                             r.max=zno.r.max,
                             sb.win=zno.bk.win,
                             sb.ord=zno.bk.ord,
                             cc.mu.px.A=fudge*df.cc[1,1],
                             do.plot=FALSE,
                             do.log=FALSE)


str.file  <- '912L2-np'

df.912L2  <- process.edp.dm(dat.path=dat.dir,
                            edp.base=str.file,
                            r.min=zno.r.min,
                            r.max=zno.r.max,
                            sb.win=zno.bk.win,
                            sb.ord=zno.bk.ord,
                            cc.mu.px.A=df.cc[2,1],
                            do.plot=FALSE,
                            do.log=FALSE)

str.file  <- '912L3-np'

df.912L3  <- process.edp.dm(dat.path=dat.dir,
                            edp.base=str.file,
                            r.min=zno.r.min,
                            r.max=zno.r.max,
                            sb.win=zno.bk.win,
                            sb.ord=zno.bk.ord,
                            cc.mu.px.A=df.cc[3,1],
                            do.plot=FALSE,
                            do.log=FALSE)


###################################################
### code chunk number 16: hiddenZnORawPlot
###################################################
# hidden code to do the plot
# do the first plot
k.min <- min(df.912L1$k,df.912L2$k,df.912L3$k)
k.max <- max(df.912L1$k,df.912L2$k,df.912L3$k)
i.max <- 1.05*max(df.912L1$int.net,df.912L2$int.net,df.912L3$int.net)
k.t <- c(k.min, k.max)
y.t <- c(0.01,i.max)

plot(k.t, y.t, type='n', xlab='k (2*pi/d) [nm]',
     ylab='net counts',
     main=NA)
lines(df.912L1$k, df.912L1$int.net, col='black')
lines(df.912L2$k, df.912L3$int.net, col='blue')
lines(df.912L3$k, df.912L3$int.net, col='slateblue')
add.icdd.lines(path='../../../global/lines/',
                card='36-1451-ZnO-P63mc',
                max.ht=2000,
                l.col='red',
                do.legend=FALSE)
l.text <- c('912L1', '912L2', '912L3', '36-1451-ZnO-P63mc')
l.col  <- c('black', 'blue', 'slateblue', 'red')
legend("topright", l.text, col=l.col, lty=1)


###################################################
### code chunk number 17: ZnORawPlot
###################################################
# hidden code to do the plot
# do the first plot
k.min <- min(df.912L1$k,df.912L2$k,df.912L3$k)
k.max <- max(df.912L1$k,df.912L2$k,df.912L3$k)
i.max <- 1.05*max(df.912L1$int.net,df.912L2$int.net,df.912L3$int.net)
k.t <- c(k.min, k.max)
y.t <- c(0.01,i.max)

plot(k.t, y.t, type='n', xlab='k (2*pi/d) [nm]',
     ylab='net counts',
     main=NA)
lines(df.912L1$k, df.912L1$int.net, col='black')
lines(df.912L2$k, df.912L3$int.net, col='blue')
lines(df.912L3$k, df.912L3$int.net, col='slateblue')
add.icdd.lines(path='../../../global/lines/',
                card='36-1451-ZnO-P63mc',
                max.ht=2000,
                l.col='red',
                do.legend=FALSE)
l.text <- c('912L1', '912L2', '912L3', '36-1451-ZnO-P63mc')
l.col  <- c('black', 'blue', 'slateblue', 'red')
legend("topright", l.text, col=l.col, lty=1)


###################################################
### code chunk number 18: hiddenZnOFudgePlot
###################################################
# hidden code to do the plot
# do the 2nd plot
k.min <- min(df.912L1.f$k,df.912L2$k,df.912L3$k)
k.max <- max(df.912L1.f$k,df.912L2$k,df.912L3$k)
i.max <- 1.05*max(df.912L1.f$int.net,df.912L2$int.net,df.912L3$int.net)
k.t <- c(k.min, k.max)
y.t <- c(0.01,i.max)

plot(k.t, y.t, type='n', xlab='k (2*pi/d) [nm]',
     ylab='net counts',
     main=NA)
lines(df.912L1.f$k, df.912L1.f$int.net, col='black')
lines(df.912L2$k, df.912L3$int.net, col='blue')
lines(df.912L3$k, df.912L3$int.net, col='slateblue')
add.icdd.lines(path='../../../global/lines/',
                card='36-1451-ZnO-P63mc',
                max.ht=2000,
                l.col='red',
                do.legend=FALSE)
l.text <- c('912L1', '912L2', '912L3', '36-1451-ZnO-P63mc')
l.col  <- c('black', 'blue', 'slateblue', 'red')
legend("topright", l.text, col=l.col, lty=1)


###################################################
### code chunk number 19: ZnOFudgePlot
###################################################
# hidden code to do the plot
# do the 2nd plot
k.min <- min(df.912L1.f$k,df.912L2$k,df.912L3$k)
k.max <- max(df.912L1.f$k,df.912L2$k,df.912L3$k)
i.max <- 1.05*max(df.912L1.f$int.net,df.912L2$int.net,df.912L3$int.net)
k.t <- c(k.min, k.max)
y.t <- c(0.01,i.max)

plot(k.t, y.t, type='n', xlab='k (2*pi/d) [nm]',
     ylab='net counts',
     main=NA)
lines(df.912L1.f$k, df.912L1.f$int.net, col='black')
lines(df.912L2$k, df.912L3$int.net, col='blue')
lines(df.912L3$k, df.912L3$int.net, col='slateblue')
add.icdd.lines(path='../../../global/lines/',
                card='36-1451-ZnO-P63mc',
                max.ht=2000,
                l.col='red',
                do.legend=FALSE)
l.text <- c('912L1', '912L2', '912L3', '36-1451-ZnO-P63mc')
l.col  <- c('black', 'blue', 'slateblue', 'red')
legend("topright", l.text, col=l.col, lty=1)


###################################################
### code chunk number 20: hiddenZnOCubicPlot
###################################################
# hidden code to do the plot
# do the 2nd plot
k.min <- min(df.912L1.f$k,df.912L2$k,df.912L3$k)
k.max <- max(df.912L1.f$k,df.912L2$k,df.912L3$k)
i.max <- 1.05*max(df.912L1.f$int.net,df.912L2$int.net,df.912L3$int.net)
k.t <- c(k.min, k.max)
y.t <- c(0.01,i.max)

plot(k.t, y.t, type='n', xlab='k (2*pi/d) [nm]',
     ylab='net counts',
     main=NA)
lines(df.912L1.f$k, df.912L1.f$int.net, col='black')
lines(df.912L2$k, df.912L3$int.net, col='blue')
lines(df.912L3$k, df.912L3$int.net, col='slateblue')
add.icdd.lines(path='../../../global/lines/',
                card='65-2880-ZnO-F43m',
                max.ht=2000,
                l.col='red',
                do.legend=FALSE)
l.text <- c('912L1', '912L2', '912L3', '65-2880-ZnO-F43m')
l.col  <- c('black', 'blue', 'slateblue', 'red')
legend("topright", l.text, col=l.col, lty=1)


###################################################
### code chunk number 21: ZnOCubicPlot
###################################################
# hidden code to do the plot
# do the 2nd plot
k.min <- min(df.912L1.f$k,df.912L2$k,df.912L3$k)
k.max <- max(df.912L1.f$k,df.912L2$k,df.912L3$k)
i.max <- 1.05*max(df.912L1.f$int.net,df.912L2$int.net,df.912L3$int.net)
k.t <- c(k.min, k.max)
y.t <- c(0.01,i.max)

plot(k.t, y.t, type='n', xlab='k (2*pi/d) [nm]',
     ylab='net counts',
     main=NA)
lines(df.912L1.f$k, df.912L1.f$int.net, col='black')
lines(df.912L2$k, df.912L3$int.net, col='blue')
lines(df.912L3$k, df.912L3$int.net, col='slateblue')
add.icdd.lines(path='../../../global/lines/',
                card='65-2880-ZnO-F43m',
                max.ht=2000,
                l.col='red',
                do.legend=FALSE)
l.text <- c('912L1', '912L2', '912L3', '65-2880-ZnO-F43m')
l.col  <- c('black', 'blue', 'slateblue', 'red')
legend("topright", l.text, col=l.col, lty=1)


###################################################
### code chunk number 22: hiddenZnOTuneBasePlot
###################################################
# hidden code to do the baseline plot
dat.dir  <- '../dat/rad/'
str.bas  <- '912L1-np'
r.start  <- 210
r.end    <- 850
bkg.ord  <- '4'
bkg.win  <- '15'

# do the work
pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                          edp.base=str.bas,
                          r.min=r.start,
                          r.max=r.end,
                          sb.win=bkg.win,
                          sb.ord=bkg.ord,
                          do.log=FALSE)



###################################################
### code chunk number 23: ZnOTuneBasePlot
###################################################
# hidden code to do the baseline plot
dat.dir  <- '../dat/rad/'
str.bas  <- '912L1-np'
r.start  <- 210
r.end    <- 850
bkg.ord  <- '4'
bkg.win  <- '15'

# do the work
pars <- tune.edp.baseline.dm(dat.path=dat.dir,
                          edp.base=str.bas,
                          r.min=r.start,
                          r.max=r.end,
                          sb.win=bkg.win,
                          sb.ord=bkg.ord,
                          do.log=FALSE)



###################################################
### code chunk number 24: Versions
###################################################
Platform <- sessionInfo()$R.version$platform
Version  <- paste(sessionInfo()$R.version$major,
                  sessionInfo()$R.version$minor,
                  sep='.')
Date     <- paste(sessionInfo()$R.version$year,
                  sessionInfo()$R.version$month,
                  sessionInfo()$R.version$day,
                  sep='-')


###################################################
### code chunk number 25: Setting up R
###################################################
# start with a clean environment
rm(list=ls())
options(digits=4, width=65, continue=" ")


###################################################
### code chunk number 26: Loading libraries
###################################################
require(xtable)
require(edp)


###################################################
### code chunk number 27: defFunctions
###################################################
# define standard error
# stderr <- function(x) sqrt(var(x)/length(x))


