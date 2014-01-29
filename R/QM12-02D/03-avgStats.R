# 03-avgStats.R


rm(list=ls())
library(xtable)

str.wd   <- "~/work/qm12-02d-02/R/R/"
i.digits <- 3



# should not need to change below here...
# set up functions
# compute the standard error
stderr <- function(x) sqrt(var(x)/length(x))

setwd(str.wd)
st <- c(-0.1168, -0.0929, -0.1286, -0.1385)
umc <- c(0.0901, 0.0715, -0.0424, -0.0329)

st.avg    <- mean(st)
st.se     <- stderr(st)
umc.avg   <- mean(umc)
umc.se    <- stderr(umc)

avg   <- c(st.avg, umc.avg)
se     <- c(st.se,  umc.se)
df.sum <- data.frame(avg=avg, se=se)
rownames(df.sum) <- c('ST', 'UMC')
colnames(df.sum) <- c('mean', 'std error')
# return the segment statistics
df.sum <- round(df.sum, i.digits)

str.tex   <- '../../TeX/methods/ana-summary.tex'
str.label <- 'tab:anaSummary'
str.align <- '|l|r|r|'
str.caption <- 'Summary of bias (AIF-SEM) by chip type'
xt.dig <- c( i.digits,  i.digits, i.digits)
xt <- xtable(df.sum, digits=xt.dig, caption=str.caption,
             label=str.label, align=str.align)

sink(str.tex)
print(xt)
sink()

str.ei <- '\\endinput'
cat(str.ei, file=str.tex, sep='\n', append=T)


