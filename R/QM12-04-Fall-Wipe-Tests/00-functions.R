# 00-functions.R
# compute the standard error
stderr <- function(x) sqrt(var(x)/length(x))

CreateVectorSummary <- function(x) {
  # create a vector of statistics
  # mean, sd, se, lcl, ucl, count
  v.min  <- min(x)
  v.mean <- mean(x)
  v.med  <- median(x)
  v.max  <- max(x)
  n <- length(x)
  v.sd <- sd(x)
  v.se <- qnorm(0.975)*v.sd/sqrt(n)
  v.lcl <- v.mean-v.se
  v.ucl <- v.mean+v.se
  
  res <- c(v.min, v.mean, v.med, v.max, v.sd, v.se, v.lcl, v.ucl, n)
  res
}


ComputeActivityAm241 <- function(dt) {
  # for Am-241 standard
  strOriDate <- c("9/11/1986  12:00:00 PM")   # For source no. 170-94
  nHalfLife <- 432.0                          # Am-241 half life
  nInitAct <- 217580.                         # dpm = 2.2 * 98900 pC
  theOriDate <- as.Date(strOriDate,format='%m/%d/%Y')
  theDiff <- as.Date(dt) - theOriDate
  nDecayDays <- as.numeric(theDiff)
  nDecayYrs <- nDecayDays / 365.25
  nFactor <- exp( -1.0 * nDecayYrs / nHalfLife)
  nAct <- nInitAct * nFactor
  nAct
}

ComputeActivityCl36 <- function(dt){
  # for Cl-36 standard
  strOriDate <- c("2/1/2000  12:00:00 PM")   # For source no. RR-659
  nHalfLife <- 3.01e+05                      # Cl-36 half life
  nInitAct <- 27310.                         # dpm
  theOriDate <- as.Date(strOriDate,format='%m/%d/%Y')
  theDiff <- as.Date(dt) - theOriDate
  nDecayDays <- as.numeric(theDiff)
  nDecayYrs <- nDecayDays / 365.25
  nFactor <- exp( -1.0 * nDecayYrs / nHalfLife)
  nAct <- nInitAct * nFactor
  nAct
}

eff.panel.plot <- function(){
  # make a panel plot of detector efficiency
  # and return a data frame with the mean and se
  par(mfrow = c(1,2))
  a.mean <- mean(alpha.stds$alpha.e.mean)
  a.se   <- stderr(alpha.stds$alpha.e.mean)
  a.sd   <- sd(alpha.stds$alpha.e.mean)
  x.t <- c(min(alpha.stds$batch), max(alpha.stds$batch))
  y.t <- c(a.mean-3*a.sd, a.mean+3*a.sd )
  plot(x.t, y.t, type='n', xlab='batch',
       ylab=expression(alpha * ' detector efficiency'))
  
  points(alpha.stds$batch, alpha.stds$alpha.e.mean, pch=19)

  abline(h=a.mean, col='red', lwd=2)
  abline(h=a.mean+a.se, col='red', lty=2, lwd=2)
  abline(h=a.mean-a.se, col='red', lty=2, lwd=2)
  abline(h=a.mean+1.96*a.sd, col='blue', lty=3, lwd=2)
  abline(h=a.mean-1.96*a.sd, col='blue', lty=3, lwd=2)
  
 
  b.mean <- mean(beta.stds$beta.e.mean)
  b.se   <- stderr(beta.stds$beta.e.mean)
  b.sd   <- sd(beta.stds$beta.e.mean)
  x.t <- c(min(beta.stds$batch), max(beta.stds$batch))
  y.t <- c(b.mean-3*b.sd, b.mean+3*b.sd )
  plot(x.t, y.t, type='n', xlab='batch',
       ylab=expression(beta * ' detector efficiency'))
  points(beta.stds$batch, beta.stds$beta.e.mean, pch=19)
  abline(h=b.mean, col='red', lwd=2)
  abline(h=b.mean+b.se, col='red', lty=2, lwd=2)
  abline(h=b.mean-b.se, col='red', lty=2, lwd=2)
  abline(h=b.mean+1.96*b.sd, col='blue', lty=3, lwd=2)
  abline(h=b.mean-1.96*b.sd, col='blue', lty=3, lwd=2)
  
  par(mfrow = c(1,1))
  
  # make a data frame with mean and se
  df.det.eff <- data.frame(alpha=c(a.mean, a.se),
                           beta=c(b.mean, b.se))
  rownames(df.det.eff) <- c('mean', 'se')
  df.det.eff <- round(df.det.eff, 4)
  # return the data frame
  df.det.eff
}

activity.panel.boxplot<- function(a,b){
  # make a panel plot of boxplots of alpha and
  # beta counts and return lists of outliers
  par(mfrow = c(1,2))
  a.bp  <- boxplot(a, ylab=expression(alpha * " Activity (pCi)"))
  a.out <- a.bp$out
  
  b.bp <- boxplot(b, ylab=expression(beta * " Activity (pCi)"))
  b.out <- b.bp$out
  
  outliers <- list(alpha=a.out, beta=b.out)
  par(mfrow = c(1,1))
  
  outliers
  
  
  
}