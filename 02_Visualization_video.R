#######################################################
# ORIGINAL: #
#######################################################
# This file produces the video of an SABM set of simulated chains.
# It relies on one sub-script, which is called individually (see "source").
# author: jimi adams
# last updated: 2018-09-13
# 
# 
# source: https://journals.sagepub.com/doi/suppl/10.1177/2378023118816545/suppl_file/02_Visualization.R
# 
# Citation:
# @article{adams2018,
#   author = {{adams}, {jimi} and Schaefer, David R.},
#   title ={Visualizing Stochastic Actor-based Model Microsteps},
#   journal = {Socius: Sociological Research for a Dynamic World},
#   volume = {4},
#   year = {2018},
#   doi = {10.1177/2378023118816545},
# }
#######################################################



#######################################################
# This is a modification of the original script. This produces 
# an mp4, not HTML, video of an SABM set of simulated chains.
# It also adds in border color for the active node, and colors 
# the active edge. 
# 
# CAUTION: Running this script requires ffmpeg, which can be
# laborious to install. 
# 
# modified by: Momin M. Malik, 2018-12-14
# "01_Model & Sim.R" available at
# https://journals.sagepub.com/doi/suppl/10.1177/2378023118816545/suppl_file/01_Model_and_Sim.R
# 
# Output video: https://youtu.be/7KJN94LritA
# 
#######################################################

#######################################################
setwd("~/Documents/") # Insert appropriate directory with "01_Model & Sim.R", or its output
# install.packages("RSiena")
# install.packages("sna")
# install.packages("lattice")
library(RSiena)
library(sna)
library(lattice)  # for plotting

source("01_Model & Sim.R")
# df is the dataframe of output micro timesteps 

## Alternatively, in the other script, run save.image("SABM.RData"), then
# load("SABM.RData")


#######################################################


#######################################################
### Next, initialize a network that corresponds to T=0, add some vertex attributes.
init <- network(s501,matrix.type="adjacency",directed=T)
set.vertex.attribute(init, "smoke", s50s[,1])
set.vertex.attribute(init, "pid", c(1:50))

### Some object-class conversions to the passed df, because their types got erased.
df$V2 <- as.numeric(df$V2)
df$V4 <- as.numeric(df$V4)
df$V5 <- as.numeric(df$V5)
df$V6 <- as.numeric(df$V6)

### Because the nodes are indexed from 0, changing their IDs (now 1-50)
df$V4 <- df$V4 + 1
df$V5[which(df$V2==0)] <- df$V5[which(df$V2==0)] + 1 
# only change for network steps (retain 0s if behavior)

### Generating a matrix of network edge toggles
df$id <- as.numeric(row.names(df)) # to get micro time step
toggles <- df[,c(12,4,5)][which (df$V2==0 & df$V11==F),] 
# 12 is the time step, (4,5) is head, tail,  
# V2=0 is for network evaluations, V11=F is for CHANGES
colnames(toggles) <- c("time", "tail", "head")

### Generating a matrix of behavior changes
beh <- df[,c(12,4,6)][which(df$V2==1 & df$V11==F),]
colnames(beh) <- c("time", "node", "change")
#######################################################

#######################################################
### Initializing the dynamic network object and some visual options to make that easily spotted.
# install.packages("networkDynamic")
library(networkDynamic)
s50d <-networkDynamic(base.net=init, edge.toggles=toggles, create.TEAs=T)

### Highlighting the node with the opportunity to make a choice
# Initializing some plotting options for that highlighting 
# (node color currently, also tried thickness and shading of vertex border)
activate.vertex.attribute(s50d, "halo", "gray50", onset=0, terminus=Inf)
# activate.vertex.attribute(s50d, "growth", 1, onset=0, terminus=Inf)
activate.vertex.attribute(s50d, "thick", 1, onset=0, terminus=Inf)
activate.edge.attribute(s50d, "linetype", 1, onset=0, terminus=Inf)
activate.edge.attribute(s50d, "linewidth", 1, onset=0, terminus=Inf)
activate.edge.attribute(s50d, "linecolor", "black", onset=0, terminus=Inf)
for (i in 1:nrow(df)){
  t <- df$id[i] # I'm just trying to keep the replace statement from getting unweildy.
  n1 <- df$V4[i]
  n2 <- df$V5[i]
  activate.vertex.attribute(s50d, "halo", "red", onset=t-1, terminus=t, v=n1)
  #activate.vertex.attribute(s50d, "growth", 20, onset=t-1, terminus=t, v=n1)
  activate.vertex.attribute(s50d, "thick", 5, onset=t-1, terminus=t, v=n1)
  activate.edges(s50d, e = get.edgeIDs(s50d, v=n1, alter=n2), onset=t-1, terminus=t)
  activate.edge.attribute(s50d, "linetype", 2,
                          e = get.edgeIDs(s50d, v=n1, alter=n2), onset=t-1, terminus=t)
  activate.edge.attribute(s50d, "linewidth", 5,
                          e = get.edgeIDs(s50d, v=n1, alter=n2), onset=t-1, terminus=t)
  activate.edge.attribute(s50d, "linecolor", "red", 
                          e = get.edgeIDs(s50d, v=n1, alter=n2), onset=t-1, terminus=t)
}

### Adding the behavior changes 
activate.vertex.attribute(s50d, "smoke", s50s[,1])
# for some reason the values from "init" aren't sticking w/ the way I assign updates, so re-attaching.
activate.vertex.attribute(s50d, "size", s50s[,1]/2) #making size relative to smoking status

for (i in 1:nrow(beh)){
  t <- beh$time[i] # I'm just trying to keep the replace statement from getting unweildy.
  n <- beh$node[i]
  d <- beh$change[i]
  curr <- get.vertex.attribute.active(s50d,'smoke',at=(t-1))[n]
  
  # This is the reassignment: current value (curr) + change (d) taking effect at onset (t) for node (n)
  activate.vertex.attribute(s50d, "smoke", curr+d, onset=t, terminus=Inf, v=n)
  # And re-setting size accordingly
  activate.vertex.attribute(s50d, "size", get.vertex.attribute.active(s50d, "smoke", at=t)[n]/2, onset=t, terminus=Inf, v=n)
}
#######################################################


#######################################################
### Plotting the network movie
# install.packages("ndtv")
library(ndtv)
palette(c("white", "gray75", "black"))

### This generates the layouts conforming to each interval (be sure to change the end back)
slice.par <- list(interval=1, aggregate.dur=1, start=0, end=nrow(df), rule="all")
## For testing, make end=10:
# slice.par <- list(interval=1, aggregate.dur=1, start=0, end=10, rule="all")
compute.animation(s50d, slice.par=slice.par, displayisolates=T)
render.par=list(tween.frames=5, show.time=T)


ani.options(ani.width = 1080, ani.height = 1080)
saveVideo(render.animation(s50d,
                           # render.par = list(tween.frames = 10),
                           edge.col="linecolor", arrowhead.cex=.5,
                           edge.lwd="linewidth", edge.lty="linetype",
                           vertex.col="smoke", vertex.lwd = "thick",
                           vertex.border = "halo", vertex.sides=50,
                           displaylabels=F, label.col="gray75", label.cex=.5,
                           displayisolates=T, ani.options=list(interval=.1),
                           main="SABM Micro Time Steps", render.cache='none'),
          other.opts = "-b 12000k",  # other.opts = "-pix_fmt yuv1080p -b 1200k"
          video.name="SABM_viz.mp4")
