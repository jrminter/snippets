rm(list=ls())
str.wd <- '~/work/snippets/R/misc/'
setwd(str.wd)

# library(checkpoint)
# checkpoint("2015-03-04")
# require(devtools)

## no way to install EBImage reproducibly
# source("http://bioconductor.org/biocLite.R")
# biocLite("EBImage")

# latest commits as of 2015-03-04
# install_github("ramnathv/rblocks", ref="a85e748390c17c752cc0ba961120d1e784fb1956")
# install_github("woobe/rPlotter", ref="7b47b9ba0897a55a86d35760acf2edca3cc7da9d")


library(rPlotter)
## extract 5 colours

# dress <- extract_colours("http://41.media.tumblr.com/a391a1b4b46dd6b498d379e50f96ecbc/tumblr_nkcjuq8Tdr1tnacy1o1_1280.jpg",3)
dress <- extract_colours("../../jpg/that-dress.jpg",3)

## plot extracted palette
par(mfrow = c(1,2))
pie(rep(1, 3), col = dress, main = "That Dress", cex.main=0.8)