# figEx.R
#
# from http://menugget.blogspot.com/2013/01/my-template-for-controlling-publication.html

###Settings specific to figure###
deg <- 2
grd <- expand.grid(x=seq(-180+deg/2,180-deg/2,deg), y=seq(-90+deg/2,90-deg/2,deg))
poly <- vector(mode="list", nrow(grd))
for(i in seq(nrow(grd))){
 xs <- c(grd$x[i]-deg/2, grd$x[i]-deg/2, grd$x[i]+deg/2, grd$x[i]+deg/2)
 ys <- c(grd$y[i]-deg/2, grd$y[i]+deg/2, grd$y[i]+deg/2, grd$y[i]-deg/2)
 poly[[i]] <- data.frame(x=xs, y=ys)
}
 
PROJ="orthographic"
ORIENT <- c(-38,178, 0)
PAR=NULL
 
 
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
png("tmp.png", width=WIDTH, height=HEIGHT, units="in", res=RESO)
#pdf("tmp.pdf", width=WIDTH, height=HEIGHT)
#x11(width=WIDTH, height=HEIGHT)
 
par(oma=OMA, ps=PS) #settings before layout
layout(LO, heights=HEIGHTS, widths=WIDTHS)
#layout.show(max(LO)) # commented out to prevent plotting during .pdf
par(cex=1) # layout has the tendency change par()$cex, so this step is important for control
 
require(maps)
require(mapdata)
require(mapproj)
 
pos <- list(x=174 + 45/60 + 51.39/3600, y=-36 - 52/60 - 38.54/3600) # position of Maunga Whau volcano
 
#plot1
par(mar=c(3,3,1,0.5))
plot(pos, t="n", col=2, xlab="", ylab="", xlim=c(168, 183), ylim=c(-43,-33))
mtext("Latitude", side=2, line=2)
mtext("Longitude", side=1, line=2)
map("worldHires", add=TRUE, fill=TRUE, col=8)
points(pos, pch=24, cex=2, col=3, bg="yellow", lwd=3)
grid()
box()
 
#plot2
par(mar=c(2,2,0,0))
require(plotrix)
map("world", proj=PROJ, orient=ORIENT, par=PAR, col=NA)
for(i in seq(poly)){
 polygon(mapproject(poly[[i]]), col="grey95", border="grey95", lwd=0.1)
}
map("world", proj=PROJ, orient=ORIENT, par=PAR, add=TRUE, resolution=0, fill=TRUE, col=8, border=8, lwd=0.001)
polygon(mapproject(c(168,168,183,183),c(-43,-33,-33,-43)), col=NA, border=1, lwd=0.5)
 
#plot3
par(mar=c(3,3,0.5,0.5))
image(x=seq(nrow(volcano)), y=seq(ncol(volcano)), z=volcano, xaxt="n", yaxt="n", col=terrain.colors(100))
abline(h=35, lty=2, col=4, lwd=2)
box()
 
#plot4
par(mar=c(3,0.5,1,4))
plot(seq(0, (nrow(volcano)-1)*10, by=10), volcano[,35], t="l", lty=2, col=4, lwd=2, xaxs="i", xaxt="n", yaxt="n")
axis(4)
mtext("[m]", side=4, line=2)
 
#outer margin text
mtext("Maunga Whau volcano transect", line=0, side=3, outer=TRUE, cex=2)
 
dev.off()