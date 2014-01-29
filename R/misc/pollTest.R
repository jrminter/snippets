# pollTest.R
# adapted from:
# http://alandgraf.blogspot.com/2012/11/quick-post-about-getting-and-plotting.html
rm(list=ls())
str.wd <- '~/work/R/'
setwd(str.wd)
source('./pollsterAPI.R')


require(XML)
require(reshape)
require(ggplot2); theme_set(theme_bw())

dat <- pollstR(pages=20)
plt <- ggplot(dat,aes(end.date,Obama/(Obama+Romney)))+
  geom_point(alpha=.5)+
  geom_smooth(aes(weight=sqrt(N)))+
  geom_hline(aes(yintercept=0.5),lty=2,size=1)+
  labs(title="Proportion of Vote for Obama",x="Last Date of Poll",
       y=NULL)
print(plt)

v.states=c("ohio","florida","virginia","colorado",
           "new-york","north-carolina")
for (s in v.states) {
  print(s)
  dat.state <- pollstR(chart=paste("2012-",s,
                                   "-president-romney-vs-obama",
                                   sep=""),pages="all")
  dat.state=subset(dat.state,
                   select=c("id","pollster","start.date",
                            "end.date","method","N","Obama","Romney"))
  dat.state$State=s
  
  if (s=="ohio") {
    dat=dat.state
  } else {
    dat=rbind(dat,dat.state)
  }
}

require(lubridate)
dat$end.date=ymd(as.character(dat$end.date))
plt2 <- ggplot(dat,aes(end.date,Obama/(Obama+Romney)))+
  geom_point(alpha=.5)+
  geom_smooth(aes(weight=sqrt(N)))+
  geom_hline(aes(yintercept=0.5),lty=2,size=1)+
  labs(title="Proportion of Vote for Obama",
       x="Last Date of Poll",y=NULL)+
  facet_wrap(~State)+
  xlim(c(mdy("8/1/2012"),mdy("11/6/2012")))

print(plt2)

# plot a second time for the pdf file
str.pdf <- './polls.pdf'
pdf.options(useDingbats=TRUE)
pdf(file="temp.pdf", width=11, height=5, pointsize=8)
print(plt2)
# Turn off device driver (to flush output to PDF)
dev.off()
# embed the fonts
embedFonts("temp.pdf","pdfwrite", str.pdf)
unlink("temp.pdf")




