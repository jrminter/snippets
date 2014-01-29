#Statistics 24600 - Spring 2004
#Instructor: Michael Eichler
#--------------------------------------------------
#Example: MCAR, MAR, NMAR
#Data   : Simulation bivariate normal distribution
#--------------------------------------------------

# ML for bivariate normal data (Y1,Y2) with missing data in Y2
ml<-function(Y) {
  x<-Y[,1]
  y<-Y[,2]
  r<-Y[,3]

  m<-mean(y[r==1])-(x[r==1]%*%y[r==1])/sum(x[r==1]^2)*(mean(x[r==1])-mean(x))
return(m)
}

# program for simulation study

simulate1<-function(m1,m2,s1,s2,rho,p) {
  # generate bivariate normal with given parameters
  x1<-matrix(rnorm(100000),100,1000)
  x2<-matrix(rnorm(100000),100,1000)
  y1<-s1*x1+m1
  y2<-rho*s2*x1+sqrt(1-rho^2)*s2*x2+m2
  # missing data indicator MCAR (Bernoulli selection)
  mcar<-matrix(rbinom(100000,1,p),100,1000)
  # missing data indicator MAR (Y2 is missing if Y1>cmar)
  cmar <-qnorm(p,m1,s1)
  mar <-ifelse(y1>cmar,0,1)
  # missing data indicator NMAR (Y2 is missing if Y2>cnmar)
  cnmar<-qnorm(p,m2,s2)
  nmar <-ifelse(y2>cnmar,0,1)
  
  # remove missing data
  Y21<-ifelse(mcar,y2,NA)
  Y22<-ifelse(mar ,y2,NA)
  Y23<-ifelse(nmar,y2,NA)
  
  # compute mean of Y2 for available cases
  m1cd<-apply(Y21,2,mean,na.rm=T)
  m2cd<-apply(Y22,2,mean,na.rm=T)
  m3cd<-apply(Y23,2,mean,na.rm=T)
  
  # compute MLE for observed data
  Y1<-array(c(y1,Y21,mcar),c(100,1000,3))
  Y2<-array(c(y1,Y22,mar),c(100,1000,3))
  Y3<-array(c(y1,Y23,nmar),c(100,1000,3))
  m1ml<-apply(Y1,2,ml)
  m2ml<-apply(Y2,2,ml)
  m3ml<-apply(Y3,2,ml)
  return(data.frame(cd1=m1cd,cd2=m2cd,cd3=m3cd,ml1=m1ml,ml2=m2ml,ml3=m3ml))
}

# set parameters of bivariate model

# do simulations
r1<-simulate1(0,0,1,1,0.0,0.8)
r2<-simulate1(0,0,1,1,0.5,0.8)
r3<-simulate1(0,0,1,1,0.9,0.8)

# summarize results

t1<-apply(r1,2,function(x) c(mu=mean(x),sd=sd(x)))
t2<-apply(r2,2,function(x) c(mu=mean(x),sd=sd(x)))
t3<-apply(r3,2,function(x) c(mu=mean(x),sd=sd(x)))

