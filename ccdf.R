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
# 
# There's a lot to fix to make this a flexible function, but I've re-used this
# code a lot for myself and want to share it. 
# 
# Plotting parameters are designed to look somewhat like what MATLAB produces,
# but (hopefully) nicer.
# 
# CAUTION: This code does not have much built-in flexibility yet. I made it for
# for long-tailed count data, so for example you would need to change some
# parameters if you have x-values between 0 and 1. 
# 
# TODO: Make ifelse for table input vs vector input
# TODO: Make ifelse for only one or neither axis in log scale
# TODO: Add min for x-axis grid and labels, for x values between 0 and 1
# TODO: More carefully cut off additional x-axis ticks above max
# TODO: Make option for lines instead of lines(type = "b"), and for color
# TODO: Automatic axis las and cex determination, maybe push xlab and ylab out
# TODO? Instead of cuting off last x-axis point, shift x-values back
# and plot P(X >= x)? Or make option to do that?
# 
# (c) Momin M. Malik 2018
# v0.9, 24 July 2018
############################################################################

# Pretty printing of scientific notation, via
# https://stackoverflow.com/questions/29785555/in-r-using-scientific-notation-10-rather-than-e
changeSciNot <- function(n) {
  output <- format(n, scientific = TRUE) # Transforms the number into scientific notation even if small
  output <- sub("e", "%*%10^", output) # Replace e with 10^
  output <- sub("\\+0?", "", output) # Remove + symbol and leading zeros on expoent, if > 1
  output <- sub("-0?", "-", output) # Leaves - symbol but removes leading zeros on expoent, if < 1
  output
}

# # If you've already made a count-frequency table via table(x), you can
# # replace the first four lines with these three lines:
# ccdf <- function(count, freq, ...) {
#   x <- count
#   y <- 1 - cumsum(freq)/sum(freq)
# Otherwise, the function inputs the vector of the distribution

# # If either the count of frequency is better plotted in linear scale,
# # you will need to replace code internally, e.g., log="y", and:
# axis(1,
#      seq(5,50,5),
#      labels = as.character(seq(5,50,5)))

# You might need to adjust the cex and/or las of the x-axis, axis(1,...)

ccdf <- function(x, ...) {
  tmp <- table(x)
  x <- as.numeric(rownames(tmp))
  y <- c(1, (1 - cumsum(tmp)/sum(tmp))[-length(x)])
  plot(x, y, 
       ylab = "P(X > x)",
       log = "xy", 
       type = "n",
       axes = F,
       xlab = "x",
       xlim = c(min(x[-length(x)]),max(x[-length(x)])),
       ylim = c(min(y[-length(x)]),max(y[-length(y)])),
       ...
  ) # Ignore the warning
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
  axis(1, # x-axis log-scale labels
       as.vector(t(t(c(1,2,5)))%*%t(10^(0:xmax))),
       labels = parse(text=changeSciNot(
         prettyNum(as.vector(t(t(c(1,2,5)))%*%t(10^(0:xmax))), format = "g")
       )),
       las = 3, # las = 1 is horizontal, las = 2 is vertical
       cex.axis = 1
  )
  axis(2, # y-axis log-scale labels
       as.vector(t(t(c(1,2,5)))%*%t(10^(-1:ymin))),
       labels = parse(text=changeSciNot(
         prettyNum(as.vector(t(t(c(1,2,5)))%*%t(10^(-1:ymin))), format = "g")
       )),
       las = 2,
       cex.axis = 1
  )
  box()
  print(lines(x,
        y,
        type="b",pch=19,col=2,cex=0.5))
}


# Examples:
ccdf(VGAM::rzipf(n = 1e4, N = 1e7, shape = .999), main = "Zipf distribution")

# If you have the poweRlaw package installed:
ccdf(poweRlaw::rpldis(n=1e4, xmin=4, alpha = 1.5), main = "Discrete power law distribution")
