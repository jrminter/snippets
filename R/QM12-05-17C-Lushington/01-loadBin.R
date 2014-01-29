# 01-loadBin.R
# This script loads raw size data from
# a .csv file, does a lognormal binning
# and saves a data frame for subsequent
# processing.
# 
# J. R. Minter Version of 19-Oct-2012
#
rm(list=ls())

str.wd <- '~/Dropbox/work/_R/_jrm/rSize/R/'
str.wd   <- '~/work/proj/QM12-05-17C/R'
str.midb <- 'qm-03779'
str.smpl <- 'LOK-6251'
str.sufx <- 'ar'
str.sample <- 'LOK-6251'
str.unit <- 'nm'
limit.hi <- 200
limit.lo <- 50
# for lognormal bins
n.root.2 <- 8.0
# for normal bins
n.breaks <- 15
b.debug <- FALSE

setwd(str.wd)
source('./funcs.R')

str.in.file <- paste('../dat/', str.midb, '-',
                     str.smpl, '-', str.sufx,
                     '.csv', sep='')
dat <- read.csv(str.in.file, as.is=T)

str.out.file <- '../dat/binned.RData'

# dat <- read.table(str.in.file, header=T, sep=",", as.is=T)
x <- dat$ecd.nm
x <- subset(x, x>limit.lo)
x <- subset(x, x<limit.hi)
n.part <- length(x)

# lognormal bins
d <- lognormal.bin(x, n.root.2)
df.ln <- as.data.frame(d[1])
l.mu <- as.numeric(d[2])
l.sd <- as.numeric(d[3])

d <- normal.bin(x, nBreaks=n.breaks)
df.n <- as.data.frame(d[1])
n.mu <- as.numeric(d[2])
n.sd <- as.numeric(d[3])

amp.est <- max(df.ln$cts)
sd.est <- l.sd
mu.est <- l.mu

# save the name and the cleaned data frame
save( str.sample, str.unit,
      mu.est, sd.est, n.part, df.ln,
      n.mu, n.sd, df.n,
      file=str.out.file)

# do a lognormal QQ plot on the data
str.title <- paste("QQ plot (Lognormal) for", str.sample)
x.lab <- paste('logormal (gmd = ', round(exp(mu.est), 1),
                sep='')
x.lab <- paste( x.lab, ' [', str.unit, '], sd = ',
                round(exp(sd.est), 3), ')', sep='')
y.lab <- paste(' log(ECD [', str.unit, '])', sep='')

l.x <- log(x)
do.ln.qq.plot = function(){
  qqplot( qnorm(ppoints(l.x), mean=mu.est, sd=sd.est),
          l.x, main = str.title, xlab=x.lab,
          ylab=y.lab, pch=20)
  
  qqline(qnorm(ppoints(l.x)), col="red", lwd=2)
}

# first for the graphics window
do.ln.qq.plot()

# plot again for the pdf file, using Dingbats
# and embed in the PDF
str.out.pdf <- paste( "../Tex/pdf/",str.sample,
                      "-qqLN.pdf", sep="")

pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=14)
do.ln.qq.plot()
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.out.pdf)
unlink("temp.pdf")

# do a normal QQ plot on the data
str.title <- paste("QQ plot (Normal) for", str.sample)
x.lab <- paste('Normal (mu = ', round(n.mu, 1),
               sep='')
x.lab <- paste( x.lab, ' [', str.unit, '], sd = ',
                round(n.sd, 1), ')', sep='')
y.lab <- paste('ECD [', str.unit, ']', sep='')

do.n.qq.plot = function(){
  qqplot( qnorm(ppoints(x), mean=n.mu, sd=n.sd),
          x, main = str.title, xlab=x.lab,
          ylab=y.lab, pch=20)
  
  qqline(qnorm(ppoints(x)), col="red", lwd=2)
}


# first for the graphics window
do.n.qq.plot()

# plot again for the pdf file, using Dingbats
# and embed in the PDF
str.out.pdf <- paste( "../Tex/pdf/",str.sample,
                      "-qqN.pdf", sep="")

pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=14)
do.n.qq.plot()
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.out.pdf)
unlink("temp.pdf")
