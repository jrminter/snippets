# downAndDirtyForecasting.R
#
# from http://0utlier.blogspot.com/2013/05/down-and-dirty-forecasting-part-1.html
# and
# http://0utlier.blogspot.com/2013/05/down-and-dirty-forecasting-part-2.html
library(forecast)
library(lmtest)
library(caret)
library(car)

#State Unemployment seasonally adjusted
#http://www.quandl.com/FRED-Federal-Reserve-Economic-Data/WIUR-Unemployment-Rate-in-Wisconsin

#Using Quandl data, great little site
wi<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/WIUR.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))

#some minor clean up
colnames(wi)<-c('date', 'rate')
wi$date<-as.Date(wi$date)
summary(wi)

#base data, 1-436, test data 437-448

wi.b<-wi[1:436,]
wi.p<-wi[437:448,]
wi.ts<-ts(wi.b$rate, start=c(1976, 1), frequency=12)
wi.p.ts<-ts(wi.p$rate, start=c(2012, 5), frequency=12)
plot.ts(wi.ts)

#Lets test some models
mean<-meanf(wi.ts, 12)
naive<-rwf(wi.ts, 12)
s.naive<-snaive(wi.ts, 12)
drift<-rwf(wi.ts, 12, drift=T)

#linear fit
m1<-tslm(wi.ts~trend)
m2<-tslm(wi.ts~trend+season)

#checking for autocorrelation
res1 <- residuals(m1)
par(mfrow=c(1,2))
plot(res1, ylab="Residuals",xlab="Year")
Acf(res1, main="ACF of residuals")

res2 <- residuals(m2)
par(mfrow=c(1,2))
plot(res2, ylab="Residuals",xlab="Year")
Acf(res2, main="ACF of residuals")
par(mfrow=c(1,1))

#Durbin-Watson Test
dwtest(m1, alt="two.sided")
dwtest(m2, alt="two.sided")
#yep autocorrelation city! No surprize here, due to the nature of unemployment

#STL ETS Decomposition
m3<-stl(wi.ts, s.window='periodic')
plot(m3)
m4<-ets(wi.ts, model='ZZZ')
plot(m4)

#ARIMA
m5<-auto.arima(wi.ts)
plot(forecast(m5, h=12))
#neural networks
m6<-nnetar(wi.ts)
m6
plot(forecast(m6, h=12))

#Testing for accuracy the first 4 models
a1<-accuracy(mean, wi.p.ts)
a2<-accuracy(naive, wi.p.ts)
a3<-accuracy(s.naive, wi.p.ts)
a4<-accuracy(drift, wi.p.ts)

a.table<-rbind(a1, a2, a3, a4)

#Creating the forecast and accuracy for the next 6 models
f1<-forecast(m1, h=12)
f2<-forecast(m2, h=12)
f3<-forecast(m3, h=12)
f4<-forecast(m4, h=12)
f5<-forecast(m5, h=12)
f6<-forecast(m6, h=12)

a5<-accuracy(f1, wi.p.ts)
a6<-accuracy(f2, wi.p.ts)
a7<-accuracy(f3, wi.p.ts)
a8<-accuracy(f4, wi.p.ts)
a9<-accuracy(f5, wi.p.ts)
a10<-accuracy(f6, wi.p.ts)

#Combining into a table with row names
a.table<-rbind(a.table, a5, a6, a7, a8, a9, a10)
row.names(a.table)<-c('Mean', 'Naive', 'S. Naive', 'Drift', 'Lm~Trend', 
                      'Lm~Trend+Sea', 'STL', 'ETS', 'ARIMA', 'Neuro')

#make into a data frame so the best model is first, according to MAPE
a.table<-as.data.frame(a.table)
a.table<-a.table[order(a.table$MAPE),]
a.table

# from http://www.google.com/reader/view/?hl=en&tab=wy#stream/user%2F16486827316166025477%2Flabel%2FR
#getting the data for WI, US, IL, MI, MN, IO

#Using Quandl data, great little site
wi<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/WIUR.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))

us<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/UNRATE.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))

il<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/ILUR.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))

mi<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/MIUR.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))

mn<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/MNUR.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))

io<-read.csv('http://www.quandl.com/api/v1/datasets/FRED/IAUR.csv?&auth_token=gigXwpxd6Ex91cjgz1B7&trim_start=1976-01-01&trim_end=2013-04-01&sort_order=desc', colClasses=c('Date'='Date'))


#merging the data into one dataframe
#I started with WI so that I could isolate the rest of the variables better
unemp<-merge(wi, io, by='Date'); colnames(unemp)<-c('Date', 'wi', 'io')
unemp<-merge(unemp, mi, by='Date'); colnames(unemp)<-c('Date', 'wi', 'io', 'mi')
unemp<-merge(unemp, mn, by='Date'); colnames(unemp)<-c('Date', 'wi', 'io', 'mi', 'mn')
unemp<-merge(unemp, us, by='Date'); colnames(unemp)<-c('Date', 'wi', 'io', 'mi', 'mn', 'us')
unemp<-merge(unemp, il, by='Date'); colnames(unemp)<-c('Date', 'wi', 'io', 'mi', 'mn', 'us', 'il')

save(unemp, file='Unemployment WI.RData')





load('Unemployment WI.RData')
unemp.b<-unemp[1:436,]
unemp.p<-unemp[437:448,]

plot(unemp$Date, unemp$us, col='black', 
     main='Unemployment WI Region', type='l', xlab='Date', 
     ylab='Unemp. Rate', ylim=c(2, 17))
lines(unemp$Date, unemp$il, col='blue')
lines(unemp$Date, unemp$io, col='dark green')
lines(unemp$Date, unemp$mi, col='purple')
lines(unemp$Date, unemp$mn, col='gray')
lines(unemp$Date, unemp$wi, col='red')
leg.txt<-c('US', 'IL', 'IO', 'MI', 'MN', "WI")
leg.col<-c('black','blue', 'dark green', 'purple', 'gray', 'red')
legend('topleft', leg.txt, col=leg.col, pch=15)

summary(unemp)

#correlation matrix

cm<-cor(unemp[,-1])
cm

#From the graph and correlation matrix, everything 
#is highly correlated, the lowest r value is 0.7879 
#between Iowa and US.
#plots of each of the data, then each individual, 
#everything looks really good, nice linear trends, 
#although Michigan has quite bit of volatility 
#compared to the other variables.

plot(unemp.b, pch='.')
model<-lm(wi~., data=unemp.b[,-1])
step.m<-step(model, direction='backward')
summary(step.m)

#testing for outliers
outlierTest(step.m)

# After conducting the outlier test, looks like it is michigan 
#Sept 1980 where unemployment was 13.2 percent, point 57 is 
#close at 12.9 those are the two biggest, but the outlierTest 
#isolated row 56

dwtest(step.m)
dwtest(step.m, alternative='two.sided')
#yep lots of autocorrelation, so a multiple ARAIMA might be in order

pred<-unemp.p[3:7]
mult.f<-predict(step.m, newdata=pred, interval='prediction')
a1<-accuracy(mult.f, unemp.p$wi)

#because the MASE is missing I needed to add the following to compare later
a1<-c(a1,'0')
names(a1)<-c("ME",  "RMSE", "MAE", "MPE", "MAPE", "MASE")


# ARIMA

auto.r<-auto.arima(unemp.b$wi, xreg=unemp.b[,3:7])
auto.r
auto.f<-forecast(auto.r, xreg=unemp.p[,3:7], h=12)
a2<-accuracy(auto.f, unemp.p$wi)
a2

#Just remember that the 0 is just a place holder
r.table<-rbind(a1, a2)
row.names(r.table)<-c('Multiple Regression', 'Reg. with ARIMA Errors')
r.table

# At this point I combined the two accuracy tables to see which one was the best.

b.table<-rbind(a.table[,1:6], r.table)
b.table<-b.table[order(b.table$MAPE),]
b.table