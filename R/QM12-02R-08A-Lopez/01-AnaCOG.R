# 01-AnaCOG.R
#
rm(list=ls())
library(xtable)

str.root     <- '~/'
str.wd       <- './work/proj/QM12-02R-08A-Lopez/R'
v.lab.id     <- c('qm-03750','qm-03751')
v.chip.id    <- c('1219ZBM-24-12', '1219ZBM-16-06' )
str.mode     <- 'raw'
n.check      <- 5
bDebug       <- F
i.cog.digits <- 2
i.dia.digits <- 3
p.cutoff     <- 0.10

#
# Should not need to change below here...
#
str.dat      <- '../dat/'
out.dir      <- '../out/'
pdf.dir      <- '../TeX/pdf/'
png.dir      <- '../TeX/png/'
tab.dir      <- '../TeX/tab/'

chp.ends <- c('SA_N002', 'SE_N511')
seg.bdry <- c('SA_N128', 'SA_N256', 'SA_N384', 'SB_N000',
              'SB_N128', 'SB_N256', 'SB_N384', 'SC_N000',
              'SC_N128', 'SC_N256', 'SC_N384', 'SD_N000',
              'SD_N128', 'SD_N256', 'SD_N384', 'SE_N000',
              'SE_N128', 'SE_N256', 'SA_N384')



setwd(str.root)
if(bDebug) print(getwd())
setwd(str.wd)
if(bDebug) print(getwd())

source ("./00-STREAM-funcs.R")
dir.create(pdf.dir, showWarnings = F, recursive = T)
dir.create(png.dir, showWarnings = F, recursive = T)
dir.create(tab.dir, showWarnings = F, recursive = T)
dir.create(out.dir, showWarnings = F, recursive = T)

num.samp <- length(v.lab.id)

# construct vectors to contain global sample stats
v.glob.id.mean   <- vector(mode="numeric", length=num.samp)
v.glob.id.se     <- vector(mode="numeric", length=num.samp)
v.glob.od.mean   <- vector(mode="numeric", length=num.samp)
v.glob.od.se     <- vector(mode="numeric", length=num.samp)
v.glob.sb.x.mean <- vector(mode="numeric", length=num.samp)
v.glob.sb.x.se   <- vector(mode="numeric", length=num.samp)
v.glob.sb.y.mean <- vector(mode="numeric", length=num.samp)
v.glob.sb.y.se   <- vector(mode="numeric", length=num.samp)

for (j in 1:num.samp)
{
  str.midb <- v.lab.id[j]
  str.chip <- v.chip.id[j]

  str.file <- paste(str.dat, str.midb,'-',
                  str.chip, '-', str.mode,
                  '.csv', sep='')
  data <- read.csv(str.file, header = TRUE, as.is=T)

  if(bDebug) print(head(data))
  noz.name <- data[, 1]
  noz.dia.inner <- data[, 3]
  noz.dia.outer <- data[, 4]
  noz.delta.cog.x <- data[, 6]
  noz.delta.cog.y <- data[, 8]

  nozzle.number <- sapply(noz.name, nozzleNumber)
  if(bDebug) print(head(nozzle.number))

  # make a data frame of what we want
  df.sem <- data.frame(nozzle.number=nozzle.number,
                     noz.dia.inner=noz.dia.inner, # um
                     noz.dia.outer=noz.dia.outer, # um
                     noz.delta.cog.x=1000*noz.delta.cog.x, # nm 
                     noz.delta.cog.y=1000*noz.delta.cog.y)

  # let's get some vectors for overall diameter stats
  v.id <- as.numeric(df.sem$noz.dia.inner)
  v.od <- as.numeric(df.sem$noz.dia.outer)
  pop.mean.id <- round(mean(v.id), i.dia.digits)
  pop.se.id   <- round(stderr(v.id), i.dia.digits)
  pop.mean.od <- round(mean(v.od), i.dia.digits)
  pop.se.od   <- round(stderr(v.od), i.dia.digits)
  
  v.glob.id.mean[j] <- pop.mean.id
  v.glob.id.se[j]   <- pop.se.id
  v.glob.od.mean[j] <- pop.mean.od
  v.glob.od.se[j]   <- pop.se.od
  
  num.bdry <- length(seg.bdry)
  num.ends <- length(chp.ends)
  num.dia  <- num.bdry+num.ends

  v.dia.noz     <- vector(mode="numeric", length=num.dia)
  v.dia.id.mean <- vector(mode="numeric", length=num.dia)
  v.dia.id.se   <- vector(mode="numeric", length=num.dia)
  v.dia.od.mean <- vector(mode="numeric", length=num.dia)
  v.dia.od.se   <- vector(mode="numeric", length=num.dia)
  
  # now analyze the left end
  left.end <- chp.ends[1]
  if(bDebug) print(left.end)

  i.pt <- 1
  v.dia.noz[i.pt] <- nozzleNumber(left.end)
  dia.left.end <- ana.end(df.sem, left.end)
  v.dia.id.mean[i.pt] <- dia.left.end[1,1]
  v.dia.od.mean[i.pt] <- dia.left.end[2,1]
  v.dia.id.se[i.pt] <- dia.left.end[1,2]
  v.dia.od.se[i.pt] <- dia.left.end[2,2]

  if(bDebug) print(num.bdry)

  df.sum <- data.frame(seg.bdry=as.character(seg.bdry),
                       mean.delta.cog.x=0,
                       p.delta.cog.x=0,
                       mean.delta.cog.y=0,
                       p.delta.cog.y=0)


  # now loop over all the segment boundaries for the chip
  for (i in 1:num.bdry)
  {
    i.pt <- i.pt + 1

    the.bdry <- seg.bdry[i]
    if(bDebug) print(the.bdry)

    t.res <- ana.bdry(df.sem, the.bdry)
    t.cog.x <- t.res["t.cog.x"]
    delta.mean.x <- unlist(t.cog.x[[1]][5])
    delta.cog.x.mean <- delta.mean.x[2] - delta.mean.x[1]
    df.sum$mean.delta.cog.x[i] <- delta.cog.x.mean
    df.sum$p.delta.cog.x[i] <- t.cog.x[[1]][3]
  
    t.cog.y <- t.res["t.cog.y"]
    delta.mean.y <- unlist(t.cog.y[[1]][5])
    delta.cog.y.mean <- delta.mean.y[2] - delta.mean.y[1]
    df.sum$mean.delta.cog.y[i] <- delta.cog.y.mean
    df.sum$p.delta.cog.y[i] <- t.cog.y[[1]][3]
  
    dia.res <- t.res["dia"]
    dia.dat <- as.numeric(unlist(dia.res))
    v.dia.noz[i.pt] <- nozzleNumber(the.bdry)
    v.dia.id.mean[i.pt] <- dia.dat[1]
    v.dia.od.mean[i.pt] <- dia.dat[2]
    v.dia.id.se[i.pt] <- dia.dat[3]
    v.dia.od.se[i.pt] <- dia.dat[4]
  
  }

  # now analyze the right end
  i.pt <- i.pt + 1
  right.end <- chp.ends[2]
  v.dia.noz[i.pt] <- nozzleNumber(right.end)
  dia.right.end <- ana.end(df.sem, right.end)
  v.dia.id.mean[i.pt] <- dia.right.end[1,1]
  v.dia.od.mean[i.pt] <- dia.right.end[2,1]
  v.dia.id.se[i.pt] <- dia.right.end[1,2]
  v.dia.od.se[i.pt] <- dia.right.end[2,2]
  
  # create a data frame for the diameter plot
  df.dia.plot <- data.frame(nozzle.number=v.dia.noz,
                          id.mean.um=round(v.dia.id.mean, i.dia.digits),
                          id.se.um=round(v.dia.id.se, i.dia.digits),
                          od.mean.um=round(v.dia.od.mean, i.dia.digits),
                          od.se.um=round(v.dia.od.se, i.dia.digits))
  rownames(df.dia.plot) <- NULL


  # plot first time for the graphics device
  the.title <- paste(str.midb,'-', str.chip, sep='')

  plot.dia(df.dia.plot, str.ti=the.title)

  # now a pdf, will ad title in the TeX caption
  str.pdf <- paste(pdf.dir, str.midb,'-',
                   str.chip,'-dia.pdf', sep='')
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  plot.dia(df.dia.plot, str.ti=NULL)
  dev.off()

  # now output a png of the plot
  str.png <- paste(png.dir, str.midb,'-',
                   str.chip,'-dia.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.dia(df.dia.plot, str.ti=the.title)
  dev.off()
  
  # create a data frame for the individual values
  # for now, let's keep the direction
  mean.delta.cog.x <- round(unlist(df.sum$mean.delta.cog.x), i.cog.digits )
  p.delta.cog.x <- round(unlist(df.sum$p.delta.cog.x), i.cog.digits )
  mean.delta.cog.y <- round(unlist(df.sum$mean.delta.cog.y), i.cog.digits )
  p.delta.cog.y <- round(unlist(df.sum$p.delta.cog.y), i.cog.digits )

  # make the data table of COG jump results
  df.bdry.cog <- data.frame(seg.bdry=as.character(unlist(seg.bdry)),
                       x.mean.nm=mean.delta.cog.x,
                       x.p=p.delta.cog.x,
                       y.mean.nm=mean.delta.cog.y,
                       y.p=p.delta.cog.y)
  rownames(df.bdry.cog) <- NULL
  
  # let's get vectors of the absolute values for the segment
  abs.mean.delta.cog.x <- abs(unlist(df.sum$mean.delta.cog.x))
  abs.mean.delta.cog.y <- abs(unlist(df.sum$mean.delta.cog.y))
  # ... and compute the global statistics
  v.glob.sb.x.mean[j]  <- mean(abs.mean.delta.cog.x)
  v.glob.sb.x.se[j]    <- stderr(abs.mean.delta.cog.x)
  v.glob.sb.y.mean[j]   <- mean(abs.mean.delta.cog.y)
  v.glob.sb.y.se[j]    <- stderr(abs.mean.delta.cog.y)
  

  # make a subset of COG-X jumps and order by probability
  df.bdry.x <- data.frame(seg.bdry=as.character(unlist(seg.bdry)),
                          x.mean.nm=mean.delta.cog.x,
                          x.p=p.delta.cog.x)
  df.bdry.sig.x <- subset(df.bdry.x, df.bdry.x$x.p <=p.cutoff)
  # order by increasing probability
  df.bdry.sig.x <- df.bdry.sig.x[order(df.bdry.sig.x$x.p),]
  rownames(df.bdry.sig.x) <- NULL


  # make a subset of COG-X jumps and order by probability
  df.bdry.y <- data.frame(seg.bdry=as.character(unlist(seg.bdry)),
                          y.mean.nm=mean.delta.cog.y,
                          y.p=p.delta.cog.y)
  df.bdry.sig.y <- subset(df.bdry.y, df.bdry.y$y.p <=p.cutoff)
  # order by increasing probability
  df.bdry.sig.y <- df.bdry.sig.y[order(df.bdry.sig.y$y.p),]
  rownames(df.bdry.sig.y) <- NULL

  # clean up the col names for the table
  names(df.bdry.cog) <- c('Boundary',
                          'mean (array) [nm]',
                          'p',
                          'mean (web) [nm]',
                          'p')

  names(df.bdry.sig.x) <- c('Boundary',
                            'mean (array) [nm]',
                            'p')

  names(df.bdry.sig.y) <- c('Boundary',
                            'mean (web) [nm]',
                            'p')
  
  # make the individual absolute X table
  if(bDebug) print(df.bdry.cog)

  str.tex <- paste(tab.dir, str.midb,'-',
                   str.chip,'-', str.mode,
                   '-cog.tex', sep='')
  str.label <- paste('tab:',str.midb,'-',
                     str.chip,'-', str.mode,
                     '-cog',sep='')
  str.caption <- paste('Jump in delta-COG at the segment boundaries from',
                       str.chip, 'using', str.mode, 'boundary detection.')
  xt <- xtable(df.bdry.cog, caption=str.caption,
               label=str.label, floating=F)

  print(xt, include.rownames=F)

  sink(str.tex)
  print(xt, include.rownames=F)
  sink()

  str.ei <- '\\endinput'
  cat(str.ei, file=str.tex, sep='\n', append=T)

  # make the sig X table
  if(bDebug) print(df.bdry.sig.x)

  str.tex <- paste(tab.dir, str.midb,'-',
                   str.chip,'-', str.mode,
                   '-sig-cog-array.tex', sep='')
  str.label <- paste('tab:',str.midb,'-',
                     str.chip,'-', str.mode,
                     '-sig-cog-array',sep='')
  str.cap <- sprintf('Jump in delta-COG (array) at the segment boundaries from %s with p <= %.2f.',
                       str.chip, p.cutoff)
  xt <- xtable(df.bdry.sig.x, caption=str.cap,
               label=str.label, floating=F)

  print(xt, include.rownames=F)

  sink(str.tex)
  print(xt, include.rownames=F)
  sink()

  str.ei <- '\\endinput'
  cat(str.ei, file=str.tex, sep='\n', append=T)



  # make the sig Y table


  if(bDebug) print(df.bdry.sig.y)

  str.tex <- paste(tab.dir, str.midb,'-',
                   str.chip,'-', str.mode,
                   '-sig-cog-web.tex', sep='')
  str.label <- paste('tab:',str.midb,'-',
                     str.chip,'-', str.mode,
                     '-sig-cog-web',sep='')
  str.cap <- sprintf('Jump in delta-COG (web) at the segment boundaries from %s with p <= %.2f.',
                   str.chip, p.cutoff)

  xt <- xtable(df.bdry.sig.y, caption=str.cap,
               label=str.label, floating=F)

  print(xt, include.rownames=F)

  sink(str.tex)
  print(xt, include.rownames=F)
  sink()

  str.ei <- '\\endinput'
  cat(str.ei, file=str.tex, sep='\n', append=T)

  # store the individuals as a csv just in case...
  str.out <- paste(out.dir, str.midb,'-',
                 str.chip,'-', str.mode,
                 '-cog.csv', sep='')
  write.csv(df.bdry.cog, str.out, row.names=F)
}

# let's make a global summary data frame
df.global <- data.frame(chip.id=v.chip.id,
                        id.mean=round(v.glob.id.mean, i.dia.digits),
                        id.se=round(v.glob.id.se, i.dia.digits),
                        od.mean=round(v.glob.od.mean, i.dia.digits),
                        od.se=round(v.glob.od.se, i.dia.digits),
                        sb.arr.mean=round(v.glob.sb.x.mean , i.cog.digits),
                        sb.arr.se=round(v.glob.sb.x.se , i.cog.digits),
                        sb.web.mean=round(v.glob.sb.y.mean , i.cog.digits),
                        sb.web.se=round(v.glob.sb.y.se , i.cog.digits))
names(df.global) <- c('chip','ID', 'se', 'OD', 'se',
                      'array', 'se', 'web', 'se')

if(bDebug) print(df.global)
str.tex <- paste(tab.dir, 'global-stats.tex', sep='')
str.label <- 'tab:globalStats'
str.caption <- 'Summary statistics (mean and standard error). Diameters are in microns, segment boundary jumps in nm.'
v.digits <-c(1, 1, 
             i.dia.digits, i.dia.digits, i.dia.digits, i.dia.digits,
             i.cog.digits, i.cog.digits,i.cog.digits, i.cog.digits)
xt <- xtable(df.global, caption=str.caption,
             label=str.label, digits=v.digits, floating=F)
print(xt, include.rownames=F)

sink(str.tex)
print(xt, include.rownames=F)
sink()
str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)





