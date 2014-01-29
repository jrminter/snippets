# InProgress.R
# for prototyping
# uses data in the environment
library(sfsmisc)


peaks <- function(series,span=3)
{
  z <- embed(series, span)
  s <- span%/%2
  v <- max.col(z, "first") == 1 + s   # take first if a tie
  result <- c(rep(FALSE,s),v)
  result <- result[1:(length(result)-s)]
  result
}


spline.par <- 0.35
# span for peak search
i.span     <- 8
# max peaks
i.max.pks  <- 25
# mi intensity (%) for a good peak 
i.min.int <- 30
#
max.pks <- 3

str.wd   <- '~/work/proj/QM12-02R-07B-Brazas/R/'
setwd(str.wd)



vec.radius <- data$radius
vec.top    <- data$top
vec.bot    <- data$bottom

df.chip <- data.frame( radius=vec.radius,
                       top=vec.top,
                       bot=vec.bot)
					  
measure.boundary.width <- function(df, spl.par=0.4, max.pk.len=15, pk.span=6, max.bound=3, i.min.pk =10, do.debug=F)
{
   # make nottion easy with vectors
   rad <- df$radius
   top <- df$top
   bot <- df$bot
   # compute the spline-smoothed 1st derivative of the top
   der.top <- abs(D1ss(rad, top, xout = rad,
                  spar.offset = 0,
                  spl.spar=spl.par))
   # set range to 100%
   mv <- max(der.top)
   der.top <- 100*der.top/mv
   
   # compute the spline-smoothed 1st derivative of the bottom
   der.bot <- abs(D1ss(rad, bot, xout = rad,
                  spar.offset = 0,
                  spl.spar=spl.par))
   mv <- max(der.bot)
   der.bot <- 100*der.bot/mv

   # find the peaks in the top
   top.peaks <- peaks(der.top, i.span)
   if(do.debug) print(summary(top.peaks))

   pk.x <- vector(mode="numeric", length=max.pk.len)
   pk.y <- vector(mode="numeric", length=max.pk.len)

   iGood <- 0
   for(i in 1:length(top.peaks))
   {
     if(top.peaks[i]!=FALSE)
     {
        iGood <- iGood+1
        pk.x[iGood] <- rad[i-1]
        pk.y[iGood] <- der.top[i]
      }
   }

   str.msg <- sprintf('Found %d peaks', iGood)
   if(do.debug) print(str.msg)

   df.peaks.top <-data.frame(x=pk.x, y=pk.y)
   df.peaks.top <- subset(df.peaks.top, df.peaks.top$y > i.min.pk)

   # sort by peak height
   df.peaks.top <- df.peaks.top[order(-df.peaks.top$y), ]
   # if there are too many, pick the max.boundaries biggest ones...
   if(nrow(df.peaks.top) > max.bound)
   {
     df.peaks.top <- df.peaks.top[1:max.bound, ]
   }
   # sort by order
   df.peaks.top <- df.peaks.top[order(df.peaks.top$x), ]
   # delete the row names
   row.names(df.peaks.top) <- NULL
   # now print them
   str.msg <- sprintf('The highest %d peaks in top profile as boundaries',  nrow(df.peaks.top))
   if(do.debug) print(str.msg)
   if(do.debug) print(df.peaks.top)

   top.bound.id <- df.peaks.top$x[1]
   top.bound.od <- df.peaks.top$x[nrow(df.peaks.top)]

   top.width <-  top.bound.od - top.bound.id
   
   val.top <- c(top.bound.id, top.bound.od, top.width)


   # find the peaks in the bottom
   bot.peaks <- peaks(der.bot, i.span)
   if(do.debug) print(summary(bot.peaks))

   pk.x <- vector(mode="numeric", length=max.pk.len)
   pk.y <- vector(mode="numeric", length=max.pk.len)

   iGood <- 0
   for(i in 1:length(bot.peaks))
   {
     if(bot.peaks[i]!=FALSE)
     {
       iGood <- iGood+1
       pk.x[iGood] <- rad[i-1]
       pk.y[iGood] <- der.bot[i]
      }
   }

   str.msg <- sprintf('Found %d peaks', iGood)
   if(do.debug) print(str.msg)

   df.peaks.bot <-data.frame(x=pk.x, y=pk.y)
   df.peaks.bot <- subset(df.peaks.bot, df.peaks.bot$y > i.min.pk)

   # sort by peak height
   df.peaks.bot <- df.peaks.bot[order(-df.peaks.bot$y), ]
   # if there are too many, pick the max.boundaries biggest ones...
   if(nrow(df.peaks.bot) > max.bound)
   {
     df.peaks.bot <- df.peaks.bot[1:max.boundaries, ]
   }

   # sort by order
   df.peaks.bot <- df.peaks.bot[order(df.peaks.bot$x), ]
   # delete the row names
   row.names(df.peaks.bot) <- NULL
   # now print them
   str.msg <- sprintf('The highest %d peaks in bot profile as boundaries', nrow(df.peaks.bot))
   if(do.debug) print(str.msg)
   if(do.debug) print(df.peaks.bot)
   
   bot.bound.id <- df.peaks.bot$x[1]
   bot.bound.od <- df.peaks.bot$x[nrow(df.peaks.bot)]

   bot.width <-  bot.bound.od - bot.bound.id
   
   val.bot <- c(bot.bound.id, bot.bound.od, bot.width)
   
   # let's prepare a data frame of output values
   val.df <- data.frame(top=val.top, bot=val.bot)
   rownames(val.df) <- c('id boundary', 'od boundary', 'width')   
   # let's prepare a data frame of profiles 
   prof.df <- data.frame(rad=rad, prof.top=top, der.top=der.top, prof.bot=bot, der.bot=der.bot)
   
   # make a list of two data frams
   ret = list("values"=val.df, "profiles"=prof.df)
   # return the list
   ret
}
plot.bdry.profiles<- function(lis, str.chp='chip', str.nz='noz')
{
  
  df.vals <- the.list$values
  df.prof <- the.list$profiles
  mx <- max(max(df.prof$prof.bot), max(df.prof$prof.top))
  oldpar <- par()
  par(mfrow = c(1,1))
  x.t <- c(4.6, 5.4)
  y.t <- c(0, 105)
  plot(x.t, y.t, type='n',
       xlab='radius [um]',
       ylab='gray level',
       main=paste(str.chp, str.nz))
  
  points(df.prof$rad, 100*df.prof$prof.bot/mx,
         pch=19, col='blue')
  x.id <- df.vals$bot[1]
  x.od <- df.vals$bot[2]
  x.t <- c(x.id, x.id)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='blue')
  x.t <- c(x.od, x.od)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='blue')
  points(df.prof$ra,  100*df.prof$prof.top/mx,
         pch=19, col='red')
  x.id <- df.vals$top[1]
  x.od <- df.vals$top[2]
  x.t <- c(x.id, x.id)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='red')
  x.t <- c(x.od, x.od)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='red')
  legend(5.1, 30,
         c('bottom','top'),
         col=c('blue', 'red'),
         pch=c(19,19))
  str.txt <- sprintf("%.3f [um]", df.vals$bot[3] )
  text(5.25, 45, str.txt, col='blue')
  
  str.txt <- sprintf("%.3f [um]", df.vals$top[3] )
  text(5.25, 36, str.txt, col='red')
  par(oldpar)
  
}

plot.bdry.deriv<- function(lis, str.chp='chip', str.nz='noz')
{
  
  df.vals <- the.list$values
  df.prof <- the.list$profiles
  mx <- max(max(df.prof$der.bot), max(df.prof$der.top))
  oldpar <- par()
  par(mfrow = c(1,1))
  x.t <- c(4.6, 5.4)
  y.t <- c(0, 105)
  plot(x.t, y.t, type='n',
       xlab='radius [um]',
       ylab='d(gray)/d(radius)',
       main=paste(str.chp, str.nz))
  
  points(df.prof$rad, 100*df.prof$der.bot/mx,
         pch=19, col='blue')
  lines(df.prof$ra,  100*df.prof$der.bot/mx,
        col='blue')
  x.id <- df.vals$bot[1]
  x.od <- df.vals$bot[2]
  x.t <- c(x.id, x.id)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='blue', lwd=1.5)
  x.t <- c(x.od, x.od)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='blue', lwd=1.5)
  points(df.prof$ra,  100*df.prof$der.top/mx,
         pch=19, col='red')
  lines(df.prof$ra,  100*df.prof$der.top/mx,
         col='red')
  x.id <- df.vals$top[1]
  x.od <- df.vals$top[2]
  x.t <- c(x.id, x.id)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='red', lwd=1.5)
  x.t <- c(x.od, x.od)
  y.t <- c(0, 105)
  lines(x.t, y.t, col='red', lwd=1.5)
  legend(5.1, 90,
         c('bottom','top'),
         col=c('blue', 'red'),
         pch=c(19,19))
  par(oldpar)
  
}
the.list <- measure.boundary.width(df.chip,
                                   spl.par=spline.par,
                                   max.pk.len=i.max.pks,
                                   pk.span=i.span,
                                   max.bound=max.pks,
                                   i.min.pk=i.min.int,
                                   do.debug=F)


plot.bdry.profiles(the.list, str.chp=str.chip, str.nz=str.noz)
plot.bdry.deriv(the.list, str.chp=str.chip, str.nz=str.noz)
