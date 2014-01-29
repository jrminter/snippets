# findCentroid.R

rm(list=ls())
setwd("~/work/R/snippets")

find.centroid <- function(x.vec, y.vec, mid.index, hw.steps){
  df <- data.frame(x=x.vec, y=y.vec)
  
  l <- nrow(df)
  l.hi <- mid.index - hw.steps
  high <- df[l.hi:l, ]
  l <- nrow(high)
  low <- high[1:(2*hw.steps)+1,]
  sumxy <- sum(low$x*low$y)
  sumy  <- sum(low$y)
  res <- sumxy/sumy
  res
}

# generate some test data

dat <- rnorm(2000, mean=25.2, sd=2.5)
h <- hist(dat, breaks=20, plot=FALSE)

x <- h$mids
y <- h$counts

y.max <- max(y)


plot(x,y)

mid.x <- which(y==y.max)

a <- find.centroid(x, y, mid.x, 3)

print(a)



