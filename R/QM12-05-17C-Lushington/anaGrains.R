# anaGrains.R
rm(list=ls())

str.wd   <- '~/work/proj/QM12-05-17C/R'
str.midb <- 'qm-03779'
str.smpl <- 'LOK-6251'
str.sufx <- 'ar'

setwd(str.wd)

lin.hist <- function(v, br=50, plt.mean=T, ...){
  # ecd histogram with empirical kernel
  # density plot
  n.pts <- length(v)
  mv <- mean(v)
  hist(v, breaks=br, probability=T, ...)
  if(plt.mean) abline(v=mv, col='blue', lw=2)
  lines(density(v), col='red')
  if(plt.mean){
    legend("topright", c('data',
                       'kernel density',
                       'mean'),
          lty=c(1,1,1),col=c('black',
                          'red',
                           'blue'))} else {
    legend("topright", c('data',
                         'kernel density'),
                          lty=c(1,1),col=c('black',
                         'red'))
                             
  }
  
}

log.hist <- function(v, br=50, plt.mean=T, ...){
  # ecd histogram with empirical kernel
  # density plot
  v <- log(v)
  n.pts <- length(v)
  mv <- mean(v)
  hist(v, breaks=br, probability=T, ...)
  if(plt.mean) abline(v=mv, col='blue', lw=2)
  lines(density(v), col='red')
  if(plt.mean){
    legend("topright", c('data',
                         'kernel density',
                         'mean'),
           lty=c(1,1,1),col=c('black',
                              'red',
                              'blue'))} else {
                                legend("topright", c('data',
                                                     'kernel density'),
                                       lty=c(1,1),col=c('black',
                                                        'red'))
                                
                              }
  
}
lin.qqplot <- function(v, ...){
  qqnorm(v, col='black', ...)
  qqline(v, col='red')
}

log.qqplot <- function(v, ...){
  v <- log(v)
  qqnorm(v, col='black', ...)
  qqline(v, col='red')
}

str.in.file <- paste('../dat/', str.midb, '-',
                     str.smpl, '-', str.sufx,
                     '.csv', sep='')
dat <- read.csv(str.in.file, as.is=T)

print(head(dat))

lin.hist(dat[,3],main=str.smpl, xlab='ECD [nm]')
lin.qqplot(dat[,3], main=str.smpl)



lin.hist(dat[,4], br=200, plt.mean=F, main=str.smpl, xlab='hexagonality')

str.out.pdf <- paste( "../TeX/pdf/",str.smpl,
                      "-hex.pdf", sep="")

pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=14)
lin.hist(dat[,4], br=200, plt.mean=F, main=str.smpl, xlab='hexagonality')
# Turn off device driver (to flush output to PDF)
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.out.pdf)
unlink("temp.pdf")

lin.qqplot(dat[,4], main=str.smpl)



log.hist(dat[,3],main=str.smpl, xlab='ECD [nm]')
log.qqplot(dat[,3], main=str.smpl)



