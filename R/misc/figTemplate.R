# figTemplate.R
# from:
# http://menugget.blogspot.com/2013/01/my-template-for-controlling-publication.html
#
#Layout of plots
#1 1 3
#1 2 3
LO <- matrix(c(2,1,1,4,1,1,3,4), nrow=2, ncol=4, byrow=TRUE)
LO #double check layout
 
#Resolution, pointsize
RESO <- 400
PS <- 10
 
#Overall units in inches
WIDTHS <- c(2,2,2,2)
HEIGHTS <- c(2,2)
OMA <- c(0,0,2,0)
HEIGHT <- sum(HEIGHTS) + OMA[1]*PS*1/72 + OMA[3]*PS*1/72
WIDTH <- sum(WIDTHS) + OMA[2]*PS*1/72 + OMA[4]*PS*1/72
 
#Double check full dimensions
WIDTH; HEIGHT 
 
 
#The plot - run from x11() down to observe behavior; run from pdf() down to produce .pdf
png("plot.png", width=WIDTH, height=HEIGHT, units="in", res=RESO)
#pdf("plot.pdf", width=WIDTH, height=HEIGHT)
#x11(width=WIDTH, height=HEIGHT)
 
 
par(oma=OMA, ps=PS) #settings before layout
layout(LO, heights=HEIGHTS, widths=WIDTHS)
#layout.show(max(LO)) # commented out to prevent plotting during .pdf
par(cex=1) # layout has the tendency change par()$cex, so this step is important for control
 
#######################
###INSERT PLOTS HERE###
#######################
 
dev.off()
