# anaNozzles.R
rm(list=ls())
require(xtable)

str.wd   <- '~/work/proj/QM12-02D-05-Kowal/R/'
pdf.dir  <- '../TeX/pdf/'
tab.dir  <- '../TeX/tab/'
i.digits <- 2
sirion.x.cal.nm <- 20.058
cd.sem.x.cal.nm <- 12.948
bDebug <- F

# should not need to change below here...
setwd(str.wd)
dir.create(pdf.dir, showWarnings = F, recursive = T)
dir.create(tab.dir, showWarnings = F, recursive = T)

cog.file <- paste('../dat/', 'Seg-Bdry-Jump-COG-X.csv',
                  sep='')

cog <- read.csv(cog.file, as.is=T)
if(bDebug) print(names(cog))

sirion.median.cogx.nm <- round(median(cog[,2]), 2)
sirion.median.cogx.px <- round(sirion.median.cogx.nm/sirion.x.cal.nm, 2)



cd.sem.median.cogx.nm <- round(median(cog[,3]), 2)
cd.sem.median.cogx.px <- round(cd.sem.median.cogx.nm/cd.sem.x.cal.nm, 2)

v.sirion.cog <- c(sirion.median.cogx.nm, sirion.median.cogx.px)
v.cd.sem.cog <- c(cd.sem.median.cogx.nm, cd.sem.median.cogx.px)
df.cog <- data.frame("EK Sirion"=v.sirion.cog, "CD SEM"=v.cd.sem.cog)
rownames(df.cog) <- c("median (nm)", "median (px)")

print(df.cog)

str.tex   <- paste(tab.dir, 'cog-stats.tex', sep='')
str.label <- 'tab:cog-stats'
str.align <- '|l|r|r|'
str.caption <- 'Median jump in $\\Delta(\\Delta COG-X))$ (nm) at the segment
                boundaries for C/F9H87-01 R5 and R9'
xt.dig <- c( i.digits,  i.digits, i.digits)
xt <- xtable(df.cog, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)



cog.plot <- function(){
  par(mfrow=c(1,3))
  plot(cog[,2], cog[,3],
       xlab=expression("Sirion " * Delta * "(" * Delta * "COG-X) (nm)"),    
       ylab=expression("CD-SEM " * Delta * "(" * Delta * "COG-X) (nm)"),
       main=NULL) # main="C/F9H87-01 R5 and R9")
  
  boxplot(cog[,2], xlab='Sirion',
          ylab=expression("Boundary " * Delta * "(" * Delta * "COG-X) (nm)"),
          ylim=c(0,20))
  stripchart(cog[,2],
             method="jitter",jitter=.075,
             pch=16, cex=1,
             col='red',
             vertical=T,add=T)
  
  boxplot(cog[,3], xlab='CD-SEM',
          ylab=expression("Boundary " * Delta * "(" * Delta * "COG-X) (nm)"),
          ylim=c(0,20))
  stripchart(cog[,3],
             method="jitter",jitter=.075,
             pch=16, cex=1,
             col='blue',
             vertical=T,add=T)
  par(mfrow=c(1,1))
}

cog.plot()

# plot second time for pdf
str.pdf <- paste(pdf.dir, 'cog-plot.pdf', sep='')
pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=9, height=6, pointsize=18)

cog.plot()

# Turn off device driver (to flush output to PDF)
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.pdf)
unlink("temp.pdf")

r5.dia.file <- paste('../dat/', 'R5-Diam.csv',
                  sep='')
r5.dia <- read.csv(r5.dia.file, as.is=T)

if(bDebug)  print(head(r5.dia))
r5.t.id <- t.test(r5.dia[,2], r5.dia[,3], paired=T)
r5.t.id.bias <- r5.t.id["estimate"][[1]][1]
r5.t.id.lcl  <- r5.t.id["conf.int"][[1]][1]
r5.t.id.ucl  <- r5.t.id["conf.int"][[1]][2]

r5.t.od <- t.test(r5.dia[,4], r5.dia[,5], paired=T)
r5.t.od.bias <- r5.t.od["estimate"][[1]][1]
r5.t.od.lcl  <- r5.t.od["conf.int"][[1]][1]
r5.t.od.ucl  <- r5.t.od["conf.int"][[1]][2]

v.r5.id <- c(mean(r5.dia[,2]), mean(r5.dia[,3]),
             r5.t.id.lcl, r5.t.id.bias, r5.t.id.ucl,
             length(r5.dia[,3]))
v.r5.od <- c(mean(r5.dia[,4]), mean(r5.dia[,5]),
             r5.t.od.lcl, r5.t.od.bias, r5.t.od.ucl,
             length(r5.dia[,4]))

r9.dia.file <- paste('../dat/', 'R9-Diam.csv',
                     sep='')
r9.dia <- read.csv(r9.dia.file, as.is=T)

if(bDebug)  print(head(r9.dia))

r9.t.id <- t.test(r9.dia[,2], r9.dia[,3], paired=T)
r9.t.id.bias <- r9.t.id["estimate"][[1]][1]
r9.t.id.lcl  <- r9.t.id["conf.int"][[1]][1]
r9.t.id.ucl  <- r9.t.id["conf.int"][[1]][2]

r9.t.od <- t.test(r9.dia[,4], r9.dia[,5], paired=T)
r9.t.od.bias <- r9.t.od["estimate"][[1]][1]
r9.t.od.lcl  <- r9.t.od["conf.int"][[1]][1]
r9.t.od.ucl  <- r9.t.od["conf.int"][[1]][2]

v.r9.id <- c(mean(r9.dia[,2]), mean(r9.dia[,3]),
             r9.t.id.lcl, r9.t.id.bias, r9.t.id.ucl,
             length(r9.dia[,3]))
v.r9.od <- c(mean(r9.dia[,4]), mean(r9.dia[,5]),
             r9.t.od.lcl, r9.t.od.bias, r9.t.od.ucl,
             length(r9.dia[,4]))

df.dia <- data.frame( "R5 ID"=v.r5.id, "R5 OD"=v.r5.od,
                      "R9 ID"=v.r9.id, "R9 OD"=v.r9.od)
df.dia <- round(df.dia, 2)
rownames(df.dia) <- c("Sirion mean", "CD-SEM mean",
                      "bias lcl", "bias mean", "bias ucl",
                      "count")


print(df.dia)

str.tex   <- paste(tab.dir, 'dia-stats.tex', sep='')
str.label <- 'tab:dia-stats'
str.align <- '|l|r|r|r|r|'
str.caption <- 'Diameter statistics (\\textmu m) for C/F9H87-01 R5 and R9'
xt.dig <- c( i.digits,  i.digits, i.digits, i.digits, i.digits)
xt <- xtable(df.dia, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)