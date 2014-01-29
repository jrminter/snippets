# 03-compDetEffic.R

rm(list=ls())
require(xtable)

source('./00-functions.R')

# by convention
dat.dir <- '../dat/'
str.ana.file <- paste(dat.dir,'wipeTest.RData')
load(str.ana.file)
str.det.eff.file <- '../dat/LastDetEff.RData'


pdf.dir  <- '../TeX/pdf/'
tab.dir  <- '../TeX/tab/'
# make sure these exist
dir.create(pdf.dir, showWarnings = F, recursive = T)
dir.create(tab.dir, showWarnings = F, recursive = T)

n.alpha <- nrow(alpha.stds)

if(n.alpha > 3){
  # compute and plot the detector efficiency, and
  # save the last values

  # compute the alpha detector efficiency
  a <- ComputeActivityAm241(alpha.stds$acq.date)

  alpha.e.mean <- alpha.stds[,4]/a
  alpha.e.se   <- alpha.stds[,5]/a

  alpha.stds$alpha.e.mean <- alpha.e.mean
  alpha.stds$alpha.e.se   <- alpha.e.se

  print(alpha.stds)


  # compute the beta detector efficiency
  a <- ComputeActivityCl36(beta.stds$acq.date)

  beta.e.mean <- beta.stds[,6]/a
  beta.e.se   <- beta.stds[,7]/a

  beta.stds$beta.e.mean <- beta.e.mean
  beta.stds$beta.e.se   <- beta.e.se

  print(beta.stds)


  # plot once for graphics window
  df.det.eff <- eff.panel.plot()

  # plot a second time for the pdf file
  str.det.eff.pdf <-paste(pdf.dir, str.ana,"-det-efficiency.pdf", sep="")
  pdf.options(useDingbats=TRUE)
  pdf(file="temp.pdf", width=9, height=6, pointsize=12)
  eff.panel.plot()
  # Turn off device driver (to flush output to PDF)
  dev.off()
  # embed the fonts
  embedFonts("temp.pdf","pdfwrite", str.det.eff.pdf)
  unlink("temp.pdf")


  print(df.det.eff)
  str.tex   <- paste(tab.dir, 'det-eff.tex', sep='')
  str.label <- 'tab:DetEff'
  str.align <- '|l|r|r|'
  str.caption <- paste('Measured Tennelec Detector Efficiency')
  xt.dig <- c( 3, 3, 3)
  xt <- xtable(df.det.eff, digits=xt.dig, caption=str.caption,
               label=str.label, align=str.align)
  
  sink(str.tex)
  print(xt, include.rownames=T)
  sink()
  
  str.ei <- '\\endinput'
  cat(str.ei, file=str.tex, sep='\n', append=T)
  
  str.det.eff.name <- str.ana

  save(df.det.eff, str.det.eff.name, file=str.det.eff.file)

} else{
  # use the last one
  load(str.det.eff.file)
  str.tex   <- paste(tab.dir, 'det-eff.tex', sep='')
  str.label <- 'tab:DetEff'
  str.align <- '|l|r|r|'
  str.caption <- paste('Previous Tennelec Detector Efficiency')
  xt.dig <- c( 3, 3, 3)
  xt <- xtable(df.det.eff, digits=xt.dig, caption=str.caption,
               label=str.label, align=str.align)
  
  sink(str.tex)
  print(xt, include.rownames=T)
  sink()
  
  str.ei <- '\\endinput'
  cat(str.ei, file=str.tex, sep='\n', append=T)
}
str.tex   <- paste(tab.dir, 'det-eff.tex', sep='')
str.label <- 'tab:DetEff'
str.align <- '|l|r|r|'
str.caption <- paste('Measured Tennelec Detector Efficiency from',
                     str.det.eff.name)
xt.dig <- c( 3, 3, 3)
xt <- xtable(df.det.eff, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt, include.rownames=T)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)

# save what we need in the analysis file
save(str.ana, alpha.stds, beta.stds,
     blanks, samples, df.det.eff,
     file=str.ana.file)






