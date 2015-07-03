# margin-of-error.R
# mine-CR use-R 20105
n <- 1000
p <- seq(0,1,.01)
me <- 2*sqrt(p*(1-p)/n)
plot(me~p, ylab="margion of error", xlab="population proportion")
