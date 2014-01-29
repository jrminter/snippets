# funcs.R for rSize
# J. R. Minter Version of 14-Jul-2012
lognormal.bin <- function(x, n.root.2=8.0)
{
  x <- subset(x, x>0)
  min.x <- min(x)
  max.x <- max(x)
  # bin by nth root of 2
  log.fact <- log(2.0)/n.root.2
  
  # print(log.fact)
  l.min.x <- log(min.x)
  l.max.x <- log(max.x)
  n.l.x.max <- ceiling(l.max.x/log.fact)
  n.l.x.min <- floor(l.min.x/log.fact)
  
  l.bins <- seq( from=n.l.x.min, to=n.l.x.max,
                 by=1) * log.fact
  l.x <- log(x)
  l.mu <- mean(l.x)
  l.sd <- sd(l.x)
  
  # now compute the histogram
  h <- hist(l.x, breaks=l.bins)
  # save what we want
  # midpoints
  h.l.x <- unlist(h[5][1])
  h.x <- exp(h.l.x)
  # counts
  h.cts <- unlist(h[2][1])
  # densities
  h.dens <-unlist(h[4][1])
  # make a data frame
  data <- data.frame(log.x=h.l.x,
                   x=h.x,
                   cts=h.cts,
                   dens=h.dens)
  # return a list
  out <-list(data, l.mu, l.sd)
  out
}

normal.bin <- function(x, nBreaks=10)
{  
  # now compute the histogram
  h <- hist(x, breaks=nBreaks)
  # save what we want
  # midpoints
  h.x <- unlist(h[5][1])
  # counts
  h.cts <- unlist(h[2][1])
  # densities
  h.dens <-unlist(h[4][1])
  # make a data frame
  data <- data.frame( x=h.x,
                      cts=h.cts,
                      dens=h.dens)
  # return a list
  mu <- mean(x)
  s <- sd(x)
  out <-list(data, mu, s)
  out
}