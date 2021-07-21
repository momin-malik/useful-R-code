as.matrix.table <- function(tab) {
  matrix(as.numeric(tab), 
         nrow = nrow(tab), 
         ncol = ncol(tab), 
         dimnames = dimnames(tab))
}
