rm(list=ls())
library(rLayerPAP)
print("Cu")
cu.bse <- papEta(29)
print(cu.bse)

print("Pd")
pd.bse <- papEta(46)
print(pd.bse)

cont <- 100*(pd.bse - cu.bse)/cu.bse
print("Contrast (%)")
print(cont)