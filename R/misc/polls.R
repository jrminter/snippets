## 
## Drew Linzer
## dlinzer@gmail.com
## August 9, 2012
## 
## pollsterAPI.R
## 
## R interface for HuffingtonPost-Pollster API
## http://elections.huffingtonpost.com/pollster/api
## 

## API access function (must be connected to Internet)

pollstR <- function(chart="2012-general-election-romney-vs-obama",pages=1) {
  # requires library(XML) and library(reshape)
  # chart: 2012-general-election-romney-vs-obama, us-right-direction-wrong-track, obama-favorable-rating,
  #        mitt-romney-favorability, obama-job-approval, obama-job-approval-economy, obama-job-approval-health,
  #        congress-job-approval, 2012-national-house-race, etc.
  # pages: number of pages of poll results to read. 10 polls per page, default is 1 most recent page.
  #        if pages="all", reads in all polls for specified chart.
  dat <- data.frame()
  if (pages=="all") { pages <- Inf }
  fin <- FALSE
  pnum <- 1
  while ((pnum <= pages) & !fin) {
    fname <- paste("http://elections.huffingtonpost.com/pollster/api/polls.xml",
                   "?chart=",chart,"&page=",pnum,sep="")
    xmltree <- tryCatch(xmlTreeParse(fname,error=NULL),XMLError=function(e) {NULL} )
    if (is.null(xmltree)) {
      cat("Alert: Chart [",chart,"] does not exist.\n")
      dat <- NULL
      fin <- TRUE
    } else {
      r <- xmlRoot(xmltree)
      if (r$name=="nil_classes") {
        fin <- TRUE
        if (pages != Inf) { cat("Alert: Page",pnum,"contained zero polls, stopping.\n") }
      } else {
        for (i in 1:length(r)) {
          poll.raw <- as.list(xmlSApply(r[[i]], xmlValue))
          poll <- data.frame(id=as.numeric(poll.raw$id),pollster=poll.raw$pollster,start.date=poll.raw$start_date,
                             end.date=poll.raw$end_date,method=poll.raw$method)
          nq <- length(r[[i]][['questions']])
          if (nq>1) {
            qvec <- NULL
            for (j in 1:length(r[[i]][['questions']])) {
              qvec <- c(qvec,ifelse(is.null(r[[i]][['questions']][[j]][['chart']][['text']]$value),
                                    NA,r[[i]][['questions']][[j]][['chart']][['text']]$value))
            }
            qindex <- which(qvec %in% chart)
          } else {
            qindex <- 1
          }
          sp <- r[[i]][['questions']][[qindex]][['subpopulations']][[1]]
          qinfo <- xmlSApply(sp,function(x) xmlSApply(x, xmlValue))
          poll$subpop <- qinfo$name
          poll$N <- ifelse(is.list(qinfo$observations),NA,as.numeric(qinfo$observations))
          res <- xmlSApply(sp[['responses']],function(x) xmlSApply(x, xmlValue))
          resvals <- data.frame(matrix(as.numeric(c(as.character(poll$id),res[2,])),nrow=1))
          names(resvals) <- c("id",res[1,])
          poll <- merge(poll,resvals)
          dat <- rbind.fill(dat,poll)
        }
        dat$start.date <- as.Date(dat$start.date)
        dat$end.date <- as.Date(dat$end.date)
        pnum <- pnum+1
      }
    }
  }
  return(dat)
}

## try it out...
library(XML)
library(reshape)
library(ggplot2); theme_set(theme_bw())
dat <- pollstR(pages=20)dat <- pollstR(pages=20)
ggplot(dat,
       aes(end.date,Obama/(Obama+Romney)))+
  geom_point(alpha=.5)+
  geom_smooth(aes(weight=sqrt(N)))+
  geom_hline(aes(yintercept=0.5),lty=2,size=1)+
  labs(title="Proportion of Vote for Obama",
      x="Last Date of Poll",y=NULL)

swing.states=c("ohio",
               "florida",
               "virginia",
               "colorado",
               "nevada",
               "new-york")
for (s in swing.states) {
  print(s)
  dat.state <- pollstR(chart=paste("2012-",s,"-president-romney-vs-obama",sep=""),pages="all")
  dat.state=subset(dat.state,select=c("id","pollster","start.date","end.date","method","N","Obama","Romney"))
  dat.state$State=s
  
  if (s=="ohio") {
    dat=dat.state
  } else {
    dat=rbind(dat,dat.state)
  }
}


library(lubridate)
dat$end.date=ymd(as.character(dat$end.date))
ggplot(dat,aes(end.date,Obama/(Obama+Romney)))+geom_point(alpha=.5)+geom_smooth(aes(weight=sqrt(N)))+geom_hline(aes(yintercept=0.5),lty=2,size=1)+
  labs(title="Proportion of Vote for Obama",x="Last Date of Poll",y=NULL)+facet_wrap(~State)+xlim(c(mdy("8/1/2012"),mdy("11/6/2012")))

