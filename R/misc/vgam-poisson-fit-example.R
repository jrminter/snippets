# from Rnews 2008-2
rm(list=ls())

require(VGAM)
set.seed(123)

alldat = data.frame(x=sort(runif(n<-500))+.2)

mymu = function(x) exp(-2 + 6*sin(2*x-0.2) / (x+0.5)^2)

alldat = transform(alldat, y = rpois(n,mymu(x)))

fit = vgam(y ~ s(x), data = alldat,
           amlpoisson(w=c(0.11, 0.9, 5.5)))

fit@extra[["percentile"]]

with(alldat, plot(x, y, col="darkgreen"))

with(alldat, matlines(x, fitted(fit), col="blue", lty=1))