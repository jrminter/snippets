# 02b-umLogNormFit
# This script loads the binned data from
# 01-loadBin.R and does a Gaussian fit
# to the logarithmically binned data
# to get a single mode lognormal fit
# 
# J. R. Minter Version of 19-Oct-2012
#
rm(list=ls())

str.wd <- '~/work/proj/QM12-05-17C/R'

b.debug <- FALSE
# set desired sizes
v.cex <- 1.4
f.cex <- 1.4
t.cex <- 1.6
st.cex <- 1.2

setwd(str.wd)
source('./funcs.R')

load('../dat/binned.RData')

amp.est <- max(df.ln$dens)
x <- df.ln$log.x
y <- df.ln$dens
n.pts <- length(x)

print(exp(mu.est))
print(exp(sd.est))

# fit a single mode lognormal
fit <- nls( y~a*exp(-(x-c)^2/(2*b^2)),
            start=list( a=amp.est,
                        b=sd.est,
                        c=mu.est),
             control=nls.control(tol=1E-5,
                                 minFactor=1/1024),
             trace=b.debug)

s <- summary(fit)
xt <- xtable(s$coefficients, digits=3,
             display=c("s", "f", "f", "f", "e"))


a <- s$coefficients[1]
b <- s$coefficients[2]
c <- s$coefficients[3]
s.e <- s$sigma[1]

x.fit <- seq(min(x),max(x),length=6*n.pts)
y.fit <- dnorm(x.fit, mean=c, sd=b)

do.the.size.plot = function(){
  x.lin.o <- exp(x)
  x.lin.c <- exp(x.fit)
  x.min <- min(x.lin.o)
  x.max <- max(x.lin.o)
  y.max <- 1.05*max(max(y), max(y.fit))
  x.t <- c(x.min, x.max)
  y.t <- c(0., y.max)
  plot(x.t, y.t, type="n",
       xlab="", ylab="", log="x", axes=FALSE)
  points(x.lin.o, y, pch=19)
  lines(x.lin.c, y.fit, col="red", lwd=2)
  gmd<- exp(c)
  gmd.x <- c(gmd,gmd)
  gmd.y <- c(0, max(y))
  lines(gmd.x,gmd.y, col="blue", lwd=2)
  
  # draw an axis on the bottom
  axis(1,cex.axis=v.cex, lwd=3)
  # draw an axis on the left
  axis(2,cex.axis=v.cex, lwd=3)
  # draw a box around the plot
  box(lwd=3)
  str.x.axis <- paste('diameter [', str.unit,
                      ' ]', sep='')
  mtext(str.x.axis, side=1, line=2, cex=v.cex)
  mtext("fraction", side=2, line=2, cex=v.cex)
  mtext(paste("Lognormal size distribution of",
              str.sample),
        side=3, line=1, cex=t.cex)
  size.text <- paste('ECD (gmd =',
                      round(exp(c), 1), str.unit)
  size.text <- paste( size.text, ', gsd = ',
                      round(exp(b), 2),
					  ', se = ', round(s.e, 4),
					  ' n = ', n.part,
                      ')', sep='')
  mtext(size.text, side=1, line=4, cex=st.cex)
}

# first for the graphics window
do.the.size.plot()

# plot again for the pdf file, using Dingbats
# and embed in the PDF
str.out.pdf <- paste( "../TeX/pdf/",str.sample,
                      "-umLN.pdf", sep="")

pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=14)
do.the.size.plot()
# Turn off device driver (to flush output to PDF)
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.out.pdf)
unlink("temp.pdf")

str.out.tex <- paste('../TeX/tab/', str.sample,
                     '-umLN.tex', sep='')
sink(file=str.out.tex)
print(xt)
sink()



