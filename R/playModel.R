# playModel.R
# inspired by:
# http://www.r-bloggers.com/teaching-linear-models/
rm(list=ls())
setwd("~/Dropbox/work/_snippets/R")
set.seed(42)
x <- 1:10
er <- rnorm(10)
y <- 2*x + 1.15*er
data <- data.frame(x=x,y=y)
plot(y~x, data)

theMod <- y ~ x
m <- model.frame(theMod, data)
m.fit <- lm(theMod, data)

print(utils::str(m))
print(head(m))
print(summary(m.fit))
abline(m.fit, col='blue', lw=2)



