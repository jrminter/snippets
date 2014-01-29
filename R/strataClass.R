# strataClass.R

rm(list=ls())

setwd("~/work/strataClass")

Cu <- list(name="Cu", z=29, line=0, obs=TRUE)
Ni <- list(name="Ni", z=28, line=0, obs=TRUE)
Pd <- list(name="Pd", z=46, line=2, obs=TRUE)
H <- list(name="H", z=1, line=0, obs=FALSE)
C <- list(name="C", z=6, line=0, obs=FALSE)
O <- list(name="O", z=8, line=0, obs=FALSE)

Substrate <- list(nEl=3,
                  eList=list(H,C,O),
                  mf=list(0.042, 0.625, 0.333),
                  rho=1.37,
                  name="PET")

Layer1 <- list(nEl=1,
               eList=list(Ni),
               mf=list(1.0),
               rho=8.90,
               th.nm=20.0,
               name="Ni")
Layer2 <- list(nEl=1,
               eList=list(Cu),
               mf=list(1.0),
               rho=8.96,
               th.nm=400.0,
               name="Cu")


# print(class(Cu))
# print(length(PET[[3]]))
# print(PET[[3]][2])
print(Layer1[[4]][[1]])
print(Layer1[[1]][[1]])
