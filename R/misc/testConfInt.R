# Compare Effects of SoilT with 95% CIs
# from http://quantitativeecology.blogspot.com/2012/07/plotting-95-confidence-bands-in-r.html
formula(glmm1)
newdat.soil <- expand.grid(
SoilT = seq(0, 30, 1),
RainAmt24 = mean(RainAmt24),
RH = mean(RH),
windspeed = mean(windspeed),
season = c(“spring”, “summer”, “fall”),
droughtdays = mean(droughtdays),
count = 0
)
newdat.soil$SoilT2 <- newdat.soil$SoilT^2
# Spring
newdat.soil.spring <- newdat.soil[newdat.soil$season == 'spring', ]
mm = model.matrix(terms(glmm1), newdat.soil)
Next I calculated the 95% confidence intervals for both the GLMM and GEE models. For the GLMM the plo and phi are the low and high confidence intervals for the fixed effects assuming zero effect of the random sites. tlo and thi account for the uncertainty in the random effects.
newdat.soil$count = mm %*% fixef(glmm1)
pvar1 <- diag(mm %*% tcrossprod(vcov(glmm1),mm))
tvar1 <- pvar1+VarCorr(glmm1)$plot[1]
newdat.soil <- data.frame(
newdat.soil
, plo = newdat.soil$count-2*sqrt(pvar1)
, phi = newdat.soil$count+2*sqrt(pvar1)
, tlo = newdat.soil$count-2*sqrt(tvar1)
, thi = newdat.soil$count+2*sqrt(tvar1)
)
mm.geeEX = model.matrix(terms(geeEX), newdat.soil)
newdat.soil$count.gee = mm.geeEX %*% coef(geeEX)
tvar1.gee <- diag(mm.geeEX %*% tcrossprod(geeEX$geese$vbeta, mm.geeEX))
newdat.soil <- data.frame(
newdat.soil
, tlo.gee = newdat.soil$count-2*sqrt(tvar1.gee)
, thi.gee = newdat.soil$count+2*sqrt(tvar1.gee)
)


plot(newdat.soil.spring$SoilT, exp(newdat.soil.spring$count.gee),
xlab = “Soil temperature (C)”,
ylab = ‘Predicted salamander observations’,
type = ‘l’,
ylim = c(0, 25))
polygon(c(newdat.soil.spring$SoilT, rev(newdat.soil.spring$SoilT)), c(exp(newdat.soil.spring$thi.gee), rev(exp(newdat.soil.spring$tlo.gee))),
col = ‘grey’,
border = NA)
lines(newdat.soil.spring$SoilT, exp(newdat.soil.spring$thi.gee),
type = ‘l’,
lty = 2)
lines(newdat.soil.spring$SoilT, exp(newdat.soil.spring$tlo.gee),
type = ‘l’,
lty = 2)
lines(newdat.soil.spring$SoilT, exp(newdat.soil.spring$count.gee),
type = ‘l’,
lty = 1,
col = 2)
lines(newdat.soil.spring$SoilT, exp(newdat.soil.spring$count),
col = 1)
lines(newdat.soil.spring$SoilT, exp(newdat.soil.spring$thi),
type = ‘l’,
lty = 2)
lines(newdat.soil.spring$SoilT, exp(newdat.soil.spring$tlo),
type = ‘l’,
lty = 2)
