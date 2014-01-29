# fitDistr.R
# from
# http://statistical-research.com/finding-the-distribution-parameters/

require(MASS)
raw <- t( matrix(c(
  1, 0.4789,
  1, 0.1250,
  2, 0.7048,
  2, 0.2482,
  2, 1.1744,
  2, 0.2313,
  2, 0.3978,
  2, 0.1133,
  2, 0.1008,
  1, 0.7850,
  2, 0.3099,
  1, 2.1243,
  2, 0.3615,
  2, 0.2386,
  1, 0.0883), nrow=2
) )
( fit.distr <- fitdistr(raw[,2], "gamma") )
qqplot(rgamma(nrow(raw),fit.distr$estimate[1], fit.distr$estimate[2]), (raw[,2]),
       xlab="Observed Data", ylab="Random Gamma")
abline(0,1,col='red')

simulated <- rgamma(1000, fit.distr$estimate[1], fit.distr$estimate[2])
hist(simulated, main=paste("Histogram of Simulated Gamma using",round(fit.distr$estimate[1],3),"and",round(fit.distr$estimate[2],3)),
     col=8, xlab="Random Gamma Distribution Value")

( fit.distr <- fitdistr(raw[,2], "normal") )
qqplot(rnorm(nrow(raw),fit.distr$estimate[1], fit.distr$estimate[2]), (raw[,2]))
abline(0,1,col='red')

( fit.distr <- fitdistr(raw[,2], "lognormal") )
qqplot(rlnorm(nrow(raw),fit.distr$estimate, fit.distr$sd), (raw[,2]))
abline(0,1,col='red')

( fit.distr <- fitdistr(raw[,2], "exponential") )
qqplot(rexp(nrow(raw),fit.distr$estimate), (raw[,2]))
abline(0,1,col='red')