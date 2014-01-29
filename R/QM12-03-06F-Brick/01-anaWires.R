# 01-anaWires.R
rm(list=ls())
require(xtable)
require(boot)
require(PerformanceAnalytics) # for skewness and excess kurtosis
require(tseries) # for jarque.bera.test

str.wd   <- '~/work/proj/QM12-03-06F-Brick/R/'
pdf.dir  <- '../TeX/pdf/'
tab.dir  <- '../TeX/tab/'
str.midb <- 'qm-03872'
str.smpl <- 'EMP-2-2'
i.digits <- 2

# should not need to change below here...
setwd(str.wd)
dir.create(pdf.dir, showWarnings = F, recursive = T)
dir.create(tab.dir, showWarnings = F, recursive = T)

lin.hist <- function(v, brk=50, plt.mean=T, ti=NULL, loc="topleft", ...){
  # histogram with empirical kernel
  # density plot
  n.pts <- length(v)
  mv <- mean(v)
  hist(v, breaks=brk, main=ti, probability=T, ...)
  if(plt.mean) abline(v=mv, col='blue', lw=2)
  lines(density(v), col='red')
  if(plt.mean){
    legend(x=loc, c('data',
                       'kernel density',
                       'mean'),
          lty=c(1,1,1),col=c('black',
                          'red',
                           'blue'))} else {
    legend(x=loc, c('data',
                         'kernel density'),
                          lty=c(1,1),col=c('black',
                         'red'))
                             
  }
  
}

lin.qqplot <- function(v, ti=NULL, ...){
  qqnorm(v, col='black', main=ti, xlab='Theoretical Quantiles',
         ylab='Sample Quantiles',...)
  qqline(v, col='red')
}


str.len.file <- paste('../dat/', str.midb, '-',
                     str.smpl, '-len.csv', sep='')
len <- read.csv(str.len.file, as.is=T)

str.dia.file <- paste('../dat/', str.midb, '-',
                      str.smpl, '-dia.csv', sep='')
dia <- read.csv(str.dia.file, as.is=T)



his.qq.plot <- function(x, quant='x', br=10,
                        title=NULL, lo="topleft", ...){
  par(mfrow=c(1,2))
  lin.hist(x, brk=br, xlab=quant, ti=title, loc=lo, ...)
  lin.qqplot(x, ...)
  par(mfrow=c(1,1))
}

his.qq.plot(len[,1], br=20, 
            quant=expression("nanowire length (" * mu * "m)"))

# plot second time for pdf
str.pdf <- paste(pdf.dir, str.smpl, '-len.pdf', sep='')
pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=12)

his.qq.plot(len[,1], br=20, 
            quant=expression("nanowire length (" * mu * "m)"))

# Turn off device driver (to flush output to PDF)
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.pdf)
unlink("temp.pdf")

# do the Jarque-Berra test for non-normality by BFI
n.obs <- length(len[,1])
len.skew  <- skewness(len[,1])
len.ekurt <- kurtosis(len[,1])
JB <- n.obs*(len.skew^2 + 0.25*len.ekurt^2)/6
print("BF&I Jarque-Berra test for non-normality of length")
print(JB)
JB <- jarque.bera.test(len[,1])
print("tseries Jarque-Berra test for non-normality of length")
print(JB)
len.jb.chisq <- JB[[1]]
len.jb.p     <- JB[[3]]



his.qq.plot(dia[,1], br=10, lo="topright",
            quant="nanowire diameter (nm)")

# plot second time for pdf
str.pdf <- paste(pdf.dir, str.smpl, '-dia.pdf', sep='')
pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=12)

his.qq.plot(dia[,1], br=10, lo="topright",
            quant="nanowire diameter (nm)")

# Turn off device driver (to flush output to PDF)
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.pdf)
unlink("temp.pdf")

# do the Jarque-Berra test for non-normality by BFI
n.obs <- length(dia[,1])
dia.skew  <- skewness(dia[,1])
dia.ekurt <- kurtosis(dia[,1])
JB <- n.obs*(dia.skew^2 + 0.25*dia.ekurt^2)/6
print("BF&I Jarque-Berra test for non-normality of diameter")
print(JB)
JB <- jarque.bera.test(dia[,1])
print("tseries Jarque-Berra test for non-normality of diameter")
print(JB)
dia.jb.chisq <- JB[[1]]
dia.jb.p     <- JB[[3]]

# now create a statistics table
v.mean      <- round(c(mean(len[,1]), mean(dia[,1])), 2)
v.sd        <- round(c(sd(len[,1]), sd(dia[,1])), 2)
v.count     <- c(nrow(len), nrow(dia))
v.jb.chisq  <- c(len.jb.chisq, dia.jb.chisq)
v.jb.p      <- c(len.jb.p, dia.jb.p)

stats <- data.frame("mean"=v.mean,
                    "std dev"=v.sd,
                    "count"=v.count,
                    "JB ChiSq"=v.jb.chisq,
                    "JB p"=v.jb.p)
rownames(stats) <- c("length (microns)", "diameter (nm)")

print(stats)

str.tex   <- paste(tab.dir, 'stats.tex', sep='')
str.label <- 'tab:stats'
str.align <- '|l|r|r|r|r|r|'
str.caption <- paste('Summary statistics for', str.smpl, 'nanowires')
xt.dig <- c( i.digits,  i.digits, i.digits, 1, i.digits, 4 )
xt <- xtable(stats, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)

mean.boot <- function(x, idx) {
  # arguments:
  # x data to be resampled
  # idx vector of scrambled indices created
  # by boot() function
  # value:
  # ans mean value computed using resampled
  # data
  ans = mean(x[idx])
  ans
}

mean.sd <- function(x, idx) {
  # arguments:
  # x data to be resampled
  # idx vector of scrambled indices created
  # by boot() function
  # value:
  # ans mean value computed using resampled
  # data
  ans = sd(x[idx])
  ans
}

len.mean.boot <- boot(len[,1], statistic = mean.boot, R=999)
len.ci.boot   <- boot.ci(len.mean.boot, conf = 0.95,
                         type=c("norm","perc"))

print(len.mean.boot)
print(len.ci.boot)

str.len.tex   <- paste(tab.dir, 'boot-len.tex', sep='')
str.beg.verb  <- '\\begin{verbatim}'
str.end.verb  <- '\\end{verbatim}'
cat(str.beg.verb, file=str.len.tex)
sink(str.len.tex, append=T)
print(len.mean.boot)
print(len.ci.boot)
sink()
cat(str.end.verb, file=str.len.tex, sep='\n', append=T)
cat(str.ei, file=str.len.tex, sep='\n', append=T)

dia.mean.boot <- boot(dia[,1], statistic = mean.boot, R=999)
dia.ci.boot   <- boot.ci(dia.mean.boot, conf = 0.95,
                         type=c("norm","perc"))

print(dia.mean.boot)
print(dia.ci.boot)

str.dia.tex   <- paste(tab.dir, 'boot-dia.tex', sep='')
cat(str.beg.verb, file=str.dia.tex)
sink(str.dia.tex, append=T)
print(dia.mean.boot)
print(dia.ci.boot)
sink()
cat(str.end.verb, file=str.dia.tex, sep='\n', append=T)
cat(str.ei, file=str.dia.tex, sep='\n', append=T)

