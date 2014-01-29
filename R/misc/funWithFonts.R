# funWithFonts.R
# from http://tucker-kellogg.com/blog/2012/10/15/using-consistent-r-and-latex-fonts-in-org-or-knitr-or-sweave/
rm(list=ls())
str.wd <- '~/Dropbox/work/_R/'
setwd(str.wd)
library(Cairo)
# mainfont <- "Garamond"
mainfont <- "Verdana"
CairoFonts(regular = paste(mainfont,"style=Regular",sep=":"),
           bold = paste(mainfont,"style=Bold",sep=":"),
           italic = paste(mainfont,"style=Italic",sep=":"),
           bolditalic = paste(mainfont,"style=Bold Italic,BoldItalic",sep=":"))
pdf <- CairoPDF
png <- CairoPNG
x <- rnorm(100)
str.title <- paste('This is a histogram using', mainfont)
hist(x,main=str.title)
pdf(file='./test.pdf')
hist(x,main=str.title)
dev.off()

