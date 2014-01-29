rm(list=ls())

require(tiff)

bx61 <- 'C:/Data/atd/images/std/Cr-line/qm-03859-IAM1-BX61-tif/qm-03859-IAM1-BX61-001.tif'

bx60 <- 'C:/Data/atd/images/std/Cr-line/qm-03860-IAM1-BX60-tif/qm-03860-IAM1-BX60-001.Tif'

myImg <- readTIFF(bx61, as.is=TRUE)

print(max(myImg))

print(str(myImg))

image(myImg, axes = FALSE, col = grey(seq(0, 1, length = 256)))
