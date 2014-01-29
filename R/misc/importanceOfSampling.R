# importanceOfSampling.R
# J. R. Minter
# 27-oct-2012

# simulate qqplots of two Gaussian samples
# from the same distributiona as a function
# of the number of samples

sim.two.norm <- function(n=10){
  set.seed(42)
  x <- rnorm(n)   # n Gaussian random numbers
  y <- rnorm(n)   # n more Gaussian random numbers
  # Do x and y come from the same distribution?
  ks.test(x, y)
  title <- paste("n =", n)
  qqplot(x,y,
         xlab="theory",
         ylab="experiment",
         main=title)
  qqline(x, col='red')
}

par(mfrow=c(2,3))

n <- 50
sim.two.norm(n)
n <- 100
sim.two.norm(n)
n <- 500
sim.two.norm(n)
n <- 1000
sim.two.norm(n)
n <- 5000
sim.two.norm(n)
n <- 10000
sim.two.norm(n)

par(mfrow=c(1,1))

