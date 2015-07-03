rm(list=ls())
oldWd <- getwd()
newWd <- Sys.getenv("TEMP")
newWd <- gsub("\\\\", "/", newWd)
newWd <- paste0(newWd, "/rEDS/")
setwd(newWd)
a <- list.files(pattern = "*.rpl")
print(a)

library(rEDS)
library(pryr)
rplFile <- paste0(newWd, "qm-04135-SBR-84.rpl")
rplFile
cube <- readDataCube(rplFile, bOpenExampleSpc = FALSE,
                     exSpecFile = "", data.what = "integer",
                     record.by.image = TRUE)

print(pryr::otype(cube))

