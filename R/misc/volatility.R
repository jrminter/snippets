# Three volatility functions
# http://eranraviv.com/blog/intraday-volatility-measures/
#

# Parkinson Volatility Estimator
Park = function(x){   
	# x is an array of prices with dimension:
	# (num.intervals.each.day)*( (5 or 6), "open", "high" etc)*(number.days) 
	n <- dim(x)[1] # number of intervals each day. 
	l <- dim(x)[3] # number of days, most recent year in my this post
	pa = NULL
 
	for (i in 1:l) {
		log.hi.lo <- log( x[1:n,2,i]/x[1:n,3,i] ) 
		pa[i] =  sum( log.hi.lo^2 )  / (4*n*log(2))
	}
	return(pa)
}

# Garman-Klass Volatility Estimator
GermanKlass = function(x){   
	# x is an array of prices with dimension:
	# (num.intervals.each.day)*( (5 or 6), "open", "high" etc)*(number.days) 
	n <- dim(x)[1] # number of intervals each day. 
 l <- dim(x)[3] # number of days 
gk = NULL
	for (i in 1:l) {
	log.hi.lo <- log( x[1:n,2,i]/x[1:n,3,i] )
	log.cl.to.cl <- log( x[2:n,4,i]/x[1:(n-1),4,i] )
		gk[i] = ( sum(.5*log.hi.lo^2) - sum( (2*log(2) - 1)*(log.cl.to.cl^2) ) ) /n
	}
	return(gk)
}

# Roger and Satchell Volatility Estimator
RogerSatchell = function(x){   
	# x is an array of prices with dimension:
	# (num.intervals.each.day)*( (5 or 6), "open", "high" etc)*(number.days) 
	n <- dim(x)[1] # number of intervals each day. 
	l <- dim(x)[3] # number of days 
	rs = NULL
 
	for (i in 1:l) {
		log.hi.cl <- log( x[1:n,2,i]/x[1:n,4,i] ) 
		log.hi.op <- log( x[1:n,2,i]/x[1:n,1,i] )
		log.lo.cl <- log( x[1:n,3,i]/x[1:n,4,i] ) 
		log.lo.op <- log( x[1:n,3,i]/x[1:n,1,i] )
 
		rs[i] =  sum( log.hi.cl*log.hi.op + log.lo.cl*log.lo.op )  /n
	}
	return(rs)
}

