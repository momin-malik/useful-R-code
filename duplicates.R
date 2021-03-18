############################################################################
# duplicated() is useful for filtering, but not for EDA, for which we want
# to see all duplicated cases, usually for a subset of variables. 
# By Momin M. Malik, 2021, momin.malik@gmail.com
# 
# This project is licensed under the terms of the MIT license.
# v1.0, 18 March 2021
############################################################################

duplicates <- function(df, vars = names(df)) {
  df[sort(unique(c(which(duplicated(df[,vars], fromLast = T)),
                   which(duplicated(df[,vars], fromLast = F))))), ]
}

which.duplicates <- function(df, vars = names(df)) {
  sort(unique(c(which(duplicated(df[,vars], fromLast = T)),
                which(duplicated(df[,vars], fromLast = F)))))
}

View.duplicates <- function(df, vars = names(df)) {
  View(df[sort(unique(c(which(duplicated(df[,vars], fromLast = T)),
                        which(duplicated(df[,vars], fromLast = F))))), ])
}
