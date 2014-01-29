# testLOESS.R
# LOESS = "Locally weighted scatterplot smoothing"
#
# from http://ucfagls.wordpress.com/2012/07/24/whats-wrong-with-loess-for-palaeo-data/
# Key point:
# With LOESS, what pattern or trend you get is determined by the
# data and crucially by the parameters chosen for the fit....
#
# Optimal LOESS fit as determined by GCV
# This model clearly overfits; the result of the GCV criterion
# not knowing that the data are temporally autocorrelated. The
# whole process assumes that the data are independent and clearly
# palaeo data often violate this critical assumption.

rm(list=ls())

loessGCV <- function (x) {
  ## Modified from code by Michael Friendly
  ## http://tolstoy.newcastle.edu.au/R/help/05/11/15899.html
  if (!(inherits(x,"loess")))
  {
    stop("Error: argument must be a loess object")
  }
  ## extract values from loess object
  span <- x$pars$span
  n <- x$n
  traceL <- x$trace.hat
  sigma2 <- sum(resid(x)^2) / (n-1)
  gcv  <- n*sigma2 / (n-traceL)^2
  result <- list(span=span, gcv=gcv)
  result
}

bestLoess <- function(model, spans = c(.05, .95)) {
  f <- function(span) {
    mod <- update(model, span = span)
    loessGCV(mod)[["gcv"]]
  }
  result <- optimize(f, spans)
  result
}

str.wd <- "~/work/R/testLOESS/R/"
setwd(str.wd)

set.seed(321)
n <- 100
time <- 1:n
xt <- time/n
Y <- (1280 * xt^4) * (1- xt)^4
y <- as.numeric(Y + arima.sim(list(ar = 0.3713), n = n))

## fit LOESS models
lo1 <- loess(y ~ xt) ## span = 0.75
lo2 <- update(lo1, span = 0.25)
lo3 <- update(lo1, span = 0.5)

COL <- "darkorange1"
layout(matrix(1:4, nrow = 2))
plot(y ~ xt, xlab = expression(x[t]), ylab = expression(y[t]),
     main = expression(lambda == 0.75))
lines(Y ~ xt, lty = "dashed", lwd = 1)
lines(fitted(lo1) ~ xt, col = COL, lwd = 2)
plot(y ~ xt, xlab = expression(x[t]), ylab = expression(y[t]),
     main = expression(lambda == 0.25))
lines(Y ~ xt, lty = "dashed", lwd = 1)
lines(fitted(lo2) ~ xt, col = COL, lwd = 2)
plot(y ~ xt, xlab = expression(x[t]), ylab = expression(y[t]),
     main = expression(lambda == 0.5))
lines(Y ~ xt, lty = "dashed", lwd = 1)
lines(fitted(lo3) ~ xt, col = COL, lwd = 2)



best <- bestLoess(lo1)
lo.gcv <- update(lo1, span = best$minimum)
str.best <- sprintf("%.3f", best$minimum)
titleNames <- c('=', str.best, '("best")')
main <- bquote( lambda ~ .(titleNames[1])
                ~.(titleNames[2]) ~.(titleNames[3]))
str.expr <- paste("lambda ==", str.best)
expr <- as.expression(str.expr)
plot(y ~ xt, xlab = expression(x[t]), ylab = expression(y[t]),
     main = main)
lines(Y ~ xt, lty = "dashed", lwd = 1)
lines(fitted(lo.gcv) ~ xt, col = COL, lwd = 2)

layout(1)


