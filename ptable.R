############################################################################
# This makes STATA-like contingency tables, letting you see the counts and 
# marginals at the same time. Currently only works for two variables. Also, 
# I haven't tested this, I gave up trying to do everything at once so there
# is probably a more efficient way to do this. 
# (c) Momin M. Malik 2018
# v1.0, 12 November 2018
############################################################################

ptable <- function(x, y, ...) {
  tmp1 <- addmargins(table(x, y, ...), margin=1:2)
  dimnames(tmp1)[[1]][length(dimnames(tmp1)[[1]])] <- "Total"
  dimnames(tmp1)[[2]][length(dimnames(tmp1)[[2]])] <- "Total"
  tmp2 <- round(100*addmargins(prop.table(table(x, y, ...), margin = 2), margin = 1), digits = 1)
  tmp1 <- as.matrix(tmp1)
  tmp2 <- as.matrix(tmp2)
  tmp2 <- cbind(tmp2, Total = round(100*tmp1[,dim(tmp1)[2]]/tmp1[length(tmp1)],1))
  tmp <- `dim<-`(sprintf('%s (%s%s)', tmp1, tmp2, "%"), dim(tmp1))
  rownames(tmp) <- dimnames(tmp1)[[1]]
  colnames(tmp) <- dimnames(tmp1)[[2]]
  # tmp <- rbind(tmp[-nrow(tmp),], `---` = "---", Total = tmp[nrow(tmp),])
  # tmp <- cbind(tmp[,-ncol(tmp)], `|` = "|", Total = tmp[,ncol(tmp)])
  return(noquote(tmp))
}
