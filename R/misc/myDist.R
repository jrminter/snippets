rm(list=ls())

r.my.dist <- function(n,df){
  x <- (rchisq(n, df=df) - df)/(sqrt(df)/.75)
  x
}

x <- r.my.dist(1000, 5000)
hist(x, probability=T)
qqnorm(x)
qqline(x)


