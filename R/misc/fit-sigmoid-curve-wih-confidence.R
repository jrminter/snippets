# fit-sigmoid-curve-wih-confidence.R
# from
# http://thebiobucket.blogspot.com/2011/04/fit-sigmoid-curve-with-confidence.html

por<-data.frame(list(structure(list(run = structure(c(1L, 1L, 1L, 1L, 2L, 2L,
2L, 2L, 3L, 3L, 3L, 3L), .Label = c("1", "3", "4"), class = "factor"),
press = c(15, 21, 24, 29.5, 15, 21, 24, 29.5, 15, 21, 24,
29.5), tr_rel = c(1, 0.459454191, 0.234697856, 0.135282651,
1, 0.853283066, 0.306314797, 0.186302231, 1, 0.42980063,
0.103882476, 0.086463799), tr = c(513, 235.7, 120.4, 69.4,
318.3, 271.6, 97.5, 59.3, 476.5, 204.8, 49.5, 41.2)), .Names = c("run",
"press", "tr_rel", "tr"), row.names = c(NA, -12L), class = "data.frame")))
 
summary(mod1<-nls(tr ~ SSlogis( log(press), Asym, xmid, scal),data=por))
 
press_x <- seq(10, 40, length = 100)
 
predict(mod1, data.frame(press = press_x))
 
with(por, plot(press,tr,xlim=c(10,35),ylim=c(0,500)))
 
lines(press_x, predict(mod1, data.frame(press = press_x)))
 
## note that the variable in SSlogis is named "press"
## and the same name should appear on the left-hand side
## of "=" in the data frame
 
###http://finzi.psych.upenn.edu/R/Rhelp02/archive/42932.html
###calc. of conf. intervalls, by linear approximation
 
se.fit <- sqrt(apply(attr(predict(mod1, data.frame(press = press_x)),"gradient"),1,
function(x) sum(vcov(mod1)*outer(x,x))))
 
###plot points and curve plus ci's
 
matplot(press_x, predict(mod1, data.frame(press = press_x))+outer(se.fit,qnorm(c(.5, .025,.975))),
type="l",lty=c(1,3,3),ylab="transp",xlab="waterpot")
with(por, matpoints(press,tr,pch=1))
 
###hhbio.wasser.tu-dresden.de/projects/modlim/doc/modlim.pdf
###R squared for non-linear Regression
 
Rsquared <- 1 - var(residuals(mod1))/var(por$tr)
 
###add r^2 to plot:
 
text(35,550,bquote(R^2==.(round(Rsquared, 3))))
asym<-coef(mod1)[1]
y_tenth<-asym*0.1
abline(h=asym)
abline(h=y_tenth,lty=5)
 
text(10,65,"10% of max. transpiration",adj=0)
 
###finding y by x
 
x<-15
y<-SSlogis(log(x), coef(mod1)[1], coef(mod1)[2] ,coef(mod1)[3])
y
 
###alternative way
###y = Asym/(1+exp((xmid-log(x))/scal))
 
y<-coef(mod1)[1]/(1+exp((coef(mod1)[2]-log(x))/coef(mod1)[3]))
 
###finding x by y
 
Asym=coef(mod1)[1]
xmid=coef(mod1)[2]
scal=coef(mod1)[3]
 
y_tenth<-asym*0.1
x_tenth<-exp((xmid-log(Asym/y_tenth-1)*scal));names(x_tenth)<-"x"
x_tenth
 
abline(v=x_tenth)
text(10,25,paste("at waterpot.:",
round(x_tenth,2)),adj=0)
