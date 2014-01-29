# regimeDetection.R
#
# Fit a Hidden Markov Model to return data to dectect a change
# from a Bull to Bear market
# from
# http://systematicinvestor.wordpress.com/2012/11/01/regime-detection/
#
###############################################################################
# Load Systematic Investor Toolbox (SIT)
# http://systematicinvestor.wordpress.com/systematic-investor-toolbox/
###############################################################################
setInternet2(TRUE)
con = gzcon(url('http://www.systematicportfolio.com/sit.gz', 'rb'))
source(con)
close(con)

#*****************************************************************
# Generate data as in the post
#****************************************************************** 
bull1 = rnorm( 100, 0.10, 0.15 )
bear  = rnorm( 100, -0.01, 0.20 )
bull2 = rnorm( 100, 0.10, 0.15 )
true.states = c(rep(1,100),rep(2,100),rep(1,100))
returns = c( bull1, bear,  bull2 )


# find regimes
load.packages('RHmm')

y=returns
ResFit = HMMFit(y, nStates=2)
VitPath = viterbi(ResFit, y)

#Forward-backward procedure, compute probabilities
fb = forwardBackward(ResFit, y)

# Plot probabilities and implied states
layout(1:2)
plot(VitPath$states, type='s', main='Implied States', xlab='', ylab='State')

matplot(fb$Gamma, type='l', main='Smoothed Probabilities', ylab='Probability')
legend(x='topright', c('State1','State2'),  fill=1:2, bty='n')

#*****************************************************************
# Add some data and see if the model is able to identify the regimes
#****************************************************************** 
bear2  = rnorm( 100, -0.01, 0.20 )
bull3 = rnorm( 100, 0.10, 0.10 )
bear3  = rnorm( 100, -0.01, 0.25 )
y = c( bull1, bear,  bull2, bear2, bull3, bear3 )
VitPath = viterbi(ResFit, y)$states

#*****************************************************************
# Plot regimes
#****************************************************************** 
load.packages('quantmod')
data = xts(y, as.Date(1:len(y)))

layout(1:3)
plota.control$col.x.highlight = col.add.alpha(true.states+1, 150)
plota(data, type='h', plotX=F, x.highlight=T)
plota.legend('Returns + True Regimes')
plota(cumprod(1+data/100), type='l', plotX=F, x.highlight=T)
plota.legend('Equity + True Regimes')

plota.control$col.x.highlight = col.add.alpha(VitPath+1, 150)
plota(data, type='h', x.highlight=T)
plota.legend('Returns + Detected Regimes')	
