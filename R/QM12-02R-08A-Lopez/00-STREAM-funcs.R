# 00-STREAM-funcs.R
#
# custom functions
# include with: source ("./00-STREAM-funcs.R")
#

# compute the standard error
stderr <- function(x) sqrt(var(x)/length(x))

# compute the nozzle number by parsing the name
nozzleNumber <- function(nozzleName, noz.per.seg=512)
{
  nozzle.number <- NA
  lA <- strsplit(nozzleName,"_")
  num.ss <- length(lA[[1]])
  if(num.ss==2)
  {
    seg <- toupper(lA[[1]][1])
    noz <- toupper(lA[[1]][2])
    lB <- strsplit(seg,"S")
    num.ssb <- length(lB[[1]])
    if(num.ssb==2)
    {
      offset <- -1
      seg.name <- (lB[[1]][2])
      if(seg.name=='A') offset=0
      if(seg.name=='B') offset=noz.per.seg
      if(seg.name=='C') offset=2*noz.per.seg
      if(seg.name=='D') offset=3*noz.per.seg
      if(seg.name=='E') offset=4*noz.per.seg
      if(offset > -1)
      {
        lC <- strsplit(noz,"N")
        num.ssc <- length(lC[[1]])
        if(num.ssc==2)
        {
          noz.num.in.seg <- as.numeric(lC[[1]][2])
          # numbers are zero based
          nozzle.number <- offset + noz.num.in.seg
        }
      }
    }
  } 
  nozzle.number
}

# plot the diameter data with error bars
plot.dia <- function(df, str.ti ='dia',
                     v.cex=1.2, a.cex=1.2,
                     t.cex=1.2, st.cex=1.2,
                     lw.pts=1, lw.bars=1,
                     len.bars =0.075)
{
  # construct the vectors we need
  x   <- df$nozzle.number
  y1   <- df$id.mean.um
  y1.u <- y1 + df$id.se.um
  y1.l <- y1 - df$id.se.um
  y2   <- df$od.mean.um
  y2.u <- y2 + df$od.se.um
  y2.l <- y2 - df$od.se.um
  
  x.t <- c(0, 2560)
  y.t <- c(min(y1.l), max(y2.u))
  
  x.lab <- "Nozzle Number"
  y.lab <- expression(paste("Diameter [", mu, "m]"))
  
  plot(x.t, y.t, type="n",
       xlab=x.lab, ylab=y.lab,
       main=str.ti) # setting up coord. system
  
  # first the id
  points(x, y1, lwd=lw.pts, lty=3, pch = 20, col="red")
  # do the error bars - 95 pct CI
  arrows(x, y1, x, y1.l, angle=90, code=2,
         length = len.bars, lwd = lw.bars)
  arrows(x, y1, x, y1.u, angle=90, code=2,
         length = len.bars, lwd = lw.bars)
  
  # next the od
  points(x, y2, lwd=lw.pts, lty=3, pch = 20, col="blue")
  # do the error bars - 95 pct CI
  arrows(x, y2, x, y2.l, angle=90, code=2,
         length = len.bars, lwd = lw.bars)
  arrows(x, y2, x, y2.u, angle=90, code=2,
         length = len.bars, lwd = lw.bars)
  
}

# plot the delta-COG-X (array dir)
# for a given segment boundary
plot.bdry.cogx <- function(df.l, df.r, str.ti ='bdry')
{
  x.min <- min(df.l$nozzle.number)
  x.max <- max(df.r$nozzle.number)
  
  
  y.min <- min(min(df.l$noz.delta.cog.x),
               min(df.r$noz.delta.cog.x))
  
  y.max <- max(max(df.l$noz.delta.cog.x),
               max(df.r$noz.delta.cog.x))
  
  x.t <- c(x.min, x.max)
  y.t <- c(y.min, y.max)
  plot(x.t, y.t, type='n', xlab='nozzle number',
       ylab='delta COG-X (array) [nm]', main = str.ti)
  points(df.l$nozzle.number, df.l$noz.delta.cog.x,
         pch=19, col='red')
  points(df.r$nozzle.number, df.r$noz.delta.cog.x,
         pch=19, col='blue')
}

# plot the delta-COG-X (web dir)
# for a given segment boundary
plot.bdry.cogy <- function(df.l, df.r, str.ti ='bdry')
{
  x.min <- min(df.l$nozzle.number)
  x.max <- max(df.r$nozzle.number)
  
  y.min <- min(min(df.l$noz.delta.cog.y),
               min(df.r$noz.delta.cog.y))
  
  y.max <- max(max(df.l$noz.delta.cog.y),
               max(df.r$noz.delta.cog.y))
  
  x.t <- c(x.min, x.max)
  y.t <- c(y.min, y.max)
  plot(x.t, y.t, type='n', xlab='nozzle number',
       ylab='delta COG-Y (web) [nm]', main = str.ti)
  points(df.l$nozzle.number, df.l$noz.delta.cog.y,
         pch=19, col='red')
  points(df.r$nozzle.number, df.r$noz.delta.cog.y,
         pch=19, col='blue')
}

# analyze the mean diameter at the nozzle end
ana.end <- function(df.res, str.end)
{
  num.hi <- nozzleNumber(str.end)
  if(bDebug) print(num.hi)
  num.lo <- num.hi - (n.check+1)
  if(bDebug) print(num.lo)
  
  df.end <- subset(df.res,
                   df.res$nozzle.number > num.lo &
                     df.res$nozzle.number < num.hi+1)
  if(bDebug) print(df.end)
  
  df.noz.mean <- sapply(df.end, mean)
  df.noz.se   <- sapply(df.end, stderr)
  v.dia.mean <- c(df.noz.mean[2], df.noz.mean[3])
  v.dia.se   <- c(df.noz.se[2], df.noz.se[3])
  df.dia <- data.frame(dia.mean=v.dia.mean, dia.se=v.dia.se)
  rownames(df.dia) <- c('ID', 'OD')
  
  df.dia
}

# analyze COG and diameter at a segment boundary
ana.bdry <- function(df.res, str.bdry)
{
  num.r.lo <- nozzleNumber(str.bdry)
  num.r.hi <- num.r.lo + n.check
  num.l.lo <- num.r.lo - (n.check+1)
  if(bDebug) print(num.r.lo)
  
  df.left <- subset(df.res,
                    df.res$nozzle.number > num.l.lo &
                      df.res$nozzle.number < num.r.lo)
  
  df.right <- subset(df.res, df.res$nozzle.number >= num.r.lo &
    df.res$nozzle.number < num.r.hi)
  if(bDebug) print(df.right)
  
  left.mean  <- sapply(df.left, mean)
  right.mean <- sapply(df.right, mean)
  left.sd    <- sapply(df.left, sd)
  right.sd   <- sapply(df.right, sd)
  left.se    <- sapply(df.left, stderr)
  right.se   <- sapply(df.right, stderr)
  
  if(bDebug) print(left.mean)
  
  
  t.cog.x <- t.test(df.left$noz.delta.cog.x, df.right$noz.delta.cog.x)
  
  str.p <- sprintf('%.3f', t.cog.x$p.value)
  str.res <- paste(str.chip, the.bdry, 'p =', str.p)
  
  # first time for the graphics device
  plot.bdry.cogx(df.left, df.right, str.ti=str.res)
  
  # now a pdf
  str.pdf <- paste(pdf.dir, str.midb,'-',
                   str.chip,'-', str.mode,'-',
                   str.bdry, '-cogx.pdf', sep='')
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  # will supply the title in the caption in LaTeX
  plot.bdry.cogx(df.left, df.right, str.ti=NULL)
  dev.off()
  
  # now a png
  str.png <- paste(png.dir, str.midb,'-',
                   str.chip,'-', str.mode, '-',
                   str.bdry, '-cogx.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.bdry.cogx(df.left, df.right, str.ti=str.res)
  dev.off()
  
  
  
  
  t.cog.y <- t.test(df.left$noz.delta.cog.y, df.right$noz.delta.cog.y)
  
  str.p <- sprintf('%.3f', t.cog.y$p.value)
  str.res <- paste(str.chip, the.bdry, 'p =', str.p)
  
  # first time for the graphics device
  plot.bdry.cogy(df.left, df.right, str.ti=str.res)
  
  # now a pdf
  str.pdf <- paste(pdf.dir, str.midb,'-',
                   str.chip,'-', str.mode, '-',
                   str.bdry, '-cogy.pdf', sep='')
  pdf(file=str.pdf, width=9, height=6, pointsize=18)
  # will supply the title in the caption in LaTeX
  plot.bdry.cogy(df.left, df.right, str.ti=NULL)
  dev.off()
  
  # now a png
  str.png <- paste(png.dir, str.midb,'-',
                   str.chip,'-', str.mode, '-',
                   str.bdry, '-cogy.png', sep='')
  png(filename=str.png, width=1024, height=768, pointsize=28)
  plot.bdry.cogy(df.left, df.right, str.ti=str.res)
  dev.off()
  
  df.noz <- subset(df.res, df.res$nozzle.number > num.l.lo &
    df.res$nozzle.number < num.r.hi)
  
  if(bDebug) print(head(df.noz))
  
  df.noz.mean <- sapply(df.noz, mean)
  df.noz.se   <- sapply(df.noz, stderr)
  v.dia.mean <- c(df.noz.mean[2], df.noz.mean[3])
  v.dia.se   <- c(df.noz.se[2], df.noz.se[3])
  df.dia <- data.frame(dia.mean=v.dia.mean, dia.se=v.dia.se)
  rownames(df.dia) <- c('ID', 'OD')
  
  
  
  l.out <- list(t.cog.x=t.cog.x, t.cog.y=t.cog.y, dia=df.dia)
  
  l.out
}