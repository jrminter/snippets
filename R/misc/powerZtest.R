### Self-made functions to perform power and sample size analysis
powerZtest = function(alpha = 0.05, sigma, n, delta){
  zcr = qnorm(p = 1-alpha, mean = 0, sd = 1)
  s = sigma/sqrt(n)
  power = 1 - pnorm(q = zcr, mean = (delta/s), sd = 1)
  return(power)
}

sampleSizeZtest = function(alpha = 0.05, sigma, power, delta){
  zcra=qnorm(p = 1-alpha, mean = 0, sd=1)
  zcrb=qnorm(p = power, mean = 0, sd = 1)
  n = round((((zcra+zcrb)*sigma)/delta)^2)
  return(n)
}

### Load pwr package to perform power and sample size analysis
library(pwr)

### Data
sigma = 15
h0 = 100
ha = 105

### Power analysis
# Using the self-made function
powerZtest(n = 20, sigma = sigma, delta = (ha-h0))
# Using the pwr package
pwr.norm.test(d = (ha - h0)/sigma, n = 20, sig.level = 0.05, alternative = "greater")

### Sample size analysis
# Using the self-made function
sampleSizeZtest(sigma = sigma, power = 0.8, delta = (ha-h0))
# Using the pwr package
pwr.norm.test(d = (ha - h0)/sigma, power = 0.8, sig.level = 0.05, alternative = "greater")

### Power function for the two-sided alternative
ha = seq(95, 125, l = 100)
d = (ha - h0)/sigma
pwrTest = pwr.norm.test(d = d, n = 20, sig.level = 0.05, alternative = "greater")$power
plot(d, pwrTest, type = "l", ylim = c(0, 1))