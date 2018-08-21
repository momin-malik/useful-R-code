############################################################################
# This script that generates nice triad census dotplots, where the actual 
# triad diagrams are plotted on the y-axis. 
# There's a lot to fix up, but the tedious work of figuring out the triads,
# and laying them out as equilateral triangles is done. Figuring out the
# plot layout is done, although maybe not quite right. 
# (c) Momin M. Malik 2016
# v1.0, 11 August 2016
############################################################################

library(igraph)

# Replace sample_gnm with your graph object
g <- sample_gnm(1000, 20000, directed = TRUE)

census.triads <- rep(list(NA),16)
names(census.triads) <- c("003","012","102","021D","021U","021C","111D","111U","030T","030C","201","120D","120U","120C","210","300")
census.triads[["003"]]  <- graph.formula(1, 2, 3) # 1, 2, 3
census.triads[["012"]]  <- graph.formula(1-+2, 2--3, 1--3) # 1-+2, 3
census.triads[["102"]]  <- graph.formula(1++2, 2--3, 1--3) # 1++2, 3
census.triads[["021D"]] <- graph.formula(1+-2, 2-+3, 1--3) # 1+-2-+3
census.triads[["021U"]] <- graph.formula(1-+2, 2+-3, 1--3) # 1-+2+-3
census.triads[["021C"]] <- graph.formula(1-+2, 2-+3, 1--3) # 1-+2-+3
census.triads[["111D"]] <- graph.formula(1++2, 2+-3, 1--3) # 1++2+-3
census.triads[["111U"]] <- graph.formula(1++2, 2-+3, 1--3) # 1++2-+3
census.triads[["030T"]] <- graph.formula(1-+2, 2+-3, 1-+3) # 1-+2+-3, 1-+3
census.triads[["030C"]] <- graph.formula(1+-2, 2+-3, 1-+3) # 1+-2+-3, 1-+3
census.triads[["201"]]  <- graph.formula(1++2, 2++3, 1--3) # 1++2++3
census.triads[["120D"]] <- graph.formula(1+-2, 2-+3, 1++3) # 1+-2-+3, 1++3
census.triads[["120U"]] <- graph.formula(1-+2, 2+-3, 1++3) # 1-+2+-3, 1++3
census.triads[["120C"]] <- graph.formula(1-+2, 2-+3, 1++3) # 1-+2-+3, 1++3
census.triads[["210"]]  <- graph.formula(1-+2, 2++3, 1++3) # 1-+2++3, 1++3
census.triads[["300"]]  <- graph.formula(1++2, 2++3, 1++3) # 1++2++3, 1++3

layout <- t(matrix(c(c(-1/sqrt(3),0),c(0,1),c(1/sqrt(3),0)),nrow=2,ncol=3))

# # Showing the triads of the census
# par(mfrow=c(4,4))
# par(mar=c(.5,.5,.5,.5))
# for (i in 1:length(census.triads)) {
#   plot(census.triads[[i]],
#        # main=names(census.triads)[i],
#        vertex.color="black",
#        vertex.label=NA,
#        edge.arrow.width=1,
#        edge.color="black",
#        layout=layout,
#        asp=1)
# }
# par(mfrow=c(1,1))
# par(mar=c(5.1,4.1,4.1,2.1))

triad.census <- triad.census(g)
names(triad.census) <- names(census.triads)

# NOTE: y-axis labels won't be aligned in RStudio in-line window. Expand or export.
pdf("triad.census.pdf", width=10, height = 7.5)
w <- 15 # Additional width past the first column
h <- 19
rpad <- 1 # Subtracts from width on right side
layout(matrix(c(1:h,rep(h+1,h*(w-rpad)),rep(h+2,h*rpad)),nrow=h),
       widths=c(rep(1,h),w-rpad,rpad),
       heights=c(rep(1,h),h,h))
# par(mfrow=c(1,16))
par(mar=c(.5,.5,.5,.5))
plot.new()
for (i in 1:length(census.triads)) {
  plot(census.triads[[i]],
       # main=names(census.triads)[i],
       vertex.color="black",
       vertex.label=NA,
       vertex.size=40,
       edge.arrow.width=1,
       edge.arrow.size=.25,
       edge.color="black",
       edge.width=1,
       layout=layout,
       asp=1)
}
plot.new()
plot.new()
par(mar=c(4.5,0,1.5,0)) # bottom, left, top, right
# dotchart(rev(triad.census))
par(font.axis = 2, xaxt = "n")
dotchart(log10(rev(triad.census)), pt.cex=1, xlim = c(0, max(log10(triad.census))))
par(font.axis = 2, xaxt = "s")
orders <- ceiling(max(log10(rev(triad.census))))
seq <- rep(c(1,2,5),orders)*rep(10^(0:(orders-1)),each=3)
segments(x0 = log10(seq), y0 = 0, y1 = 17, col="lightgray", lty=3)
axis(1, labels = seq, at = log10(seq), cex.axis = 1, font = 1)
plot.new()
dev.off()
par(mar=c(5.1,4.1,4.1,2.1))
par(mfrow=c(1,1))
