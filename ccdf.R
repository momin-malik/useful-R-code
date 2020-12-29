############################################################################
# This script generates complementary cumulative distribution function
# (i.e. survival) plots, which is the recommended way to visualize long-
# tailed distributions as per
# @article{clauset2009,
#   author = {Clauset, Aaron and 
#             Shalizi, Cosma Rohilla and 
#             Newman, Mark E. J.},
#   doi = {10.1137/070710111},
#   journal = {SIAM Review},
#   number = {4},
#   pages = {661--703},
#   title = {Power-law distributions in empirical data},
#   volume = {51},
#   year = {2009}
# }
# Plotting parameters are designed to look somewhat like what MATLAB produces,
# but (hopefully) nicer.
# CAUTION: This code does not have much built-in flexibility yet. I made it for
# for long-tailed *count* data, so for example you would need to change some
# code if you have x-values between 0 and 1. 
# TODO: Make ifelse for only one or neither axis in log scale
# By Momin M. Malik, 2018-2020, momin.malik@gmail.com
# 
# This project is licensed under the terms of the MIT license.
# v1.0, 29 December 2020
############################################################################

# Pretty printing of scientific notation
changeSciNot <- function(num, tenonly = FALSE) {
  # Transforms the number into scientific notation even if small
  output <- format(num, format = "g", digits = 1, scientific = TRUE)
  # Replace e with 10^, only if it is a multiple of 10
  output <- sub("e", ifelse(tenonly && substr(as.character(output), 1, 1) == "1", 
                            "10^", "%*%10^"), output)
  # Remove + symbol and leading zeros on exponent, if > 1
  output <- sub("\\+0?", "", output)
  # Leaves - symbol but removes leading zeros on exponent, if < 1
  output <- sub("-0?", "-", output)
  if (tenonly) {
    output <- sub("110", "10", output)
  }
  return(output)
}

ccdf <- function(v, 
                 is.table = FALSE,
                 addone = FALSE, 
                 scientific = TRUE, 
                 tenonly.x = FALSE, 
                 tenonly.y = FALSE, 
                 cex.axis.x = .8,
                 cex.axis.y = .8,
                 las.x = 2,
                 las.y = 2,
                 type = "b",
                 pch = 19,
                 col = 2,
                 cex = .5,
                 ...) {
  if (is.table) {tmp <- v} else {tmp <- table(v)}
  x <- as.numeric(rownames(tmp))
  if (addone) {x <- x + 1}
  y <- c(1, (1 - cumsum(tmp)/sum(tmp))[-length(x)])
  plot(x, y,
       ylab = "P(X > x)",
       log = "xy",
       type = "n",
       axes = F,
       xlab = ifelse(addone, "x + 1", "x"),
       xlim = c(max(1,min(x[-length(x)])),max(x[-length(x)])),
       ylim = c(min(y[-length(x)]),max(y[-length(y)])),
       ...
  )
  xmax <- ceiling(log10(max(x[-length(x)])))
  ymin <- floor(log10(min(y[-length(y)])))
  abline( # vertical log-scale grid lines for x-axis
    v = as.vector(t(t(1:9))%*%t(10^(0:xmax))),
    lty = 3,
    col = colors()[ 440 ]
  )
  abline( # horizontal log-scale grid lines for y-axis
    h = as.vector(t(t(1:9))%*%t(10^(-1:ymin))),
    lty = 3,
    col = colors()[ 440 ]
  )
  at.x <- if (tenonly.x) {10^(0:xmax)} else {as.vector(t(t(c(1,2,5)))%*%t(10^(0:xmax)))}
  at.y <- if (tenonly.y) {10^(-1:ymin)} else {as.vector(t(t(c(1,2,5)))%*%t(10^(-1:ymin)))}
  axis(side = 1, # x-axis log-scale labels
       at = at.x, 
       labels = if(scientific) {parse(text=changeSciNot(at.x, 
                                                        tenonly.x))} else {at.x},
       las = las.x, # las = 1 is horizontal, las = 2 is vertical
       cex.axis = cex.axis.x)
  axis(side = 2, # y-axis log-scale labels
       at = at.y, 
       labels = if(scientific) {parse(text=changeSciNot(at.y, 
                                                        tenonly.y))} else {at.y},
       las = las.y,
       cex.axis = cex.axis.y)
  box()
  lines(x, y,
        type = type, pch = pch, col = col, cex = cex)
}

# If you have VGAM installed:
ccdf(VGAM::rzipf(n = 1e4, N = 1e7, shape = .999), 
     main = "Zipf distribution")
ccdf(VGAM::rzipf(n = 1e4, N = 1e7, shape = .999), 
     main = "Zipf distribution", 
     las.x = 2)
ccdf(VGAM::rzipf(n = 1e4, N = 1e7, shape = .999), 
     main = "Zipf distribution", 
     tenonly.x = T, 
     tenonly.y = T)

# If you have the poweRlaw installed:
ccdf(poweRlaw::rpldis(n=1e4, xmin=4, alpha = 1.5), 
     main = "Discrete power law distribution")