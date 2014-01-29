# anaKJL-031.R

rm(list=ls())
library(analab)
setwd("~/work/proj/trTunedSep/R")

str.in <- '../dat/csv/qm-03966-KJL-031.csv'

do.pdf <- TRUE
pdf.pts <- 12

df <- read.csv(str.in, header=FALSE, skip=2, as.is=TRUE)
names(df) <- c('part', 'class', 'area.sq.nm', 'ecd.nm',
              'aspect.ratio', 'convexity', 'elongation',
              'shape.factor', 'sphericity')

print(head(df))

n.brks = 250

Sys.sleep(0.1)
linear.distn.panel.plot(df$shape.factor, n.brks, kern.bw="nrd0", distn.lab='shape factor')
if(do.pdf){
  str.pdf <- "../Sweave/inc/qm-03966-KJL-031-shape-plot.pdf"
  d.cur <- dev.cur()
  dev.copy2pdf(device=d.cur, file="temp.pdf", useDingbats=TRUE, pointsize=pdf.pts)
  str.cmd <- sprintf("pdfcrop --margins 10 temp.pdf %s", str.pdf)
  system(str.cmd)
  unlink("temp.pdf")
}

Sys.sleep(0.1)
linear.distn.panel.plot(df$convexity, n.brks, kern.bw="nrd0", distn.lab='convexity')
if(do.pdf){
  str.pdf <- "../Sweave/inc/qm-03966-KJL-031-convex-plot.pdf"
  d.cur <- dev.cur()
  dev.copy2pdf(device=d.cur, file="temp.pdf", useDingbats=TRUE, pointsize=pdf.pts)
  str.cmd <- sprintf("pdfcrop --margins 10 temp.pdf %s", str.pdf)
  system(str.cmd)
  unlink("temp.pdf")
}

Sys.sleep(0.1)
linear.distn.panel.plot(df$aspect.ratio, n.brks, kern.bw="nrd0", distn.lab='aspect ratio')
if(do.pdf){
  str.pdf <- "../Sweave/inc/qm-03966-KJL-031-ar-plot.pdf"
  d.cur <- dev.cur()
  dev.copy2pdf(device=d.cur, file="temp.pdf", useDingbats=TRUE, pointsize=pdf.pts)
  str.cmd <- sprintf("pdfcrop --margins 10 temp.pdf %s", str.pdf)
  system(str.cmd)
  unlink("temp.pdf")
}

df <- df[df$aspect.ratio < 1.17,]
df <- df[df$ecd.nm > 5,]
df <- df[df$convexity > 0.95,]

KJL.31ecd.med <- round(median(df$ecd.nm),1)
KJL.31ecd.sd <- round(sd(df$ecd.nm), 1)
count <- nrow(df)

KJL.31.stats <- c(KJL.31ecd.med, KJL.31ecd.sd, count)
names(KJL.31.stats) <- c("median ECD [nm]", "sd ECD [nm]", "count")
save(KJL.31.stats, file='../dat/KJL.31.stats.RData')

print(KJL.31.stats)


# print(summary(df))
Sys.sleep(0.1)
linear.distn.panel.plot(df$ecd.nm, n.brks=15, kern.bw="nrd0",
                        distn.lab='diameter [nm]')
if(do.pdf){
  str.pdf <- "../Sweave/inc/qm-03966-KJL-031-ecd-plot.pdf"
  d.cur <- dev.cur()
  dev.copy2pdf(device=d.cur, file="temp.pdf", useDingbats=TRUE, pointsize=pdf.pts)
  str.cmd <- sprintf("pdfcrop --margins 10 temp.pdf %s", str.pdf)
  system(str.cmd)
  unlink("temp.pdf")
}