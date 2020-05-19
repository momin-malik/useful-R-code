############################################################################
# This script takes data from the US Census Bureau's MDAT tool for
# American Community Survey (ACS) data, which is output as nested 
# contingency tables, and puts it into a "tidy" format.
# 
# I HAVE NOT TESTED THIS EXTENSIVELY. My use case had 3 column 
# variables and 3 row variables. 
# 
# PLEASE! Use the commented-out View() commands to verify that 
# the ordering is the same, and do some spot checks of values
# for any use of this script. 
# 
# Unfortunately, it may be necessary to specify the names of row 
# variables, as for me the middle of the 3 row variables did not 
# have its name appear anywhere in the export.csv file. 
# 
# TODO: Code to automatically extract column names, at least. 
# 
# (c) Momin M. Malik 2020
# v1.0, 19 May 2020
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
############################################################################
setwd("~/Downloads")
library(tidyr)

#### Specify row/column variable names ####
rowvarnames <- c("SELECTED GEOGRAPHIES",
                 "NP_RC1",
                 "RACBLK")
colvarnames <- c("POVPIP_RC1",
                 "BLD",
                 "MULTG")

#### Extract data+variables ####
input <- read.csv("export.csv", header = F, stringsAsFactors = F)[-(1:3),]
# Make index of actual data entries
index <- suppressWarnings(which(!is.na(sapply(input, as.numeric)), arr.ind = T))
# Copy out rows with column variables, columns with row variables
rowvarsraw <- input[,1] # First column is row variables
colvarsraw <- input[1:(min(index[,1])-1),-1] # Take out first column
# Extract the raw counts
counts <- type.convert(input[which(1:nrow(input) %in% index[,1]), 
                             which(1:ncol(input) %in% index[,2])])
rm(input, index)

#### Parse row variables ####
rowvarsraw <- rowvarsraw[rowvarsraw!=""] # Remove blank rows
# " -> "'s are subindexes for variable values. Use this.
tmp <- suppressWarnings(Reduce(rbind, 
                        strsplit(rowvarsraw[grep("^ ->", 
                                                 rowvarsraw)], 
                                 split = " -> ")))[,-1] # First column is blank
# Create a list of row variables: variable name, and values
rowvars <- sapply(1:ncol(tmp), function(i) unique(tmp[tmp[,i]!="",i]))
# This only doesn't catch the *last* row variable. Input values without " - >", 
# after the first one (which will be the variable name) are those values. 
rowvars[[rowvarnames[length(rowvarnames)]]] <- 
  unique(rowvarsraw[!grepl(pattern = "^ ->", x = rowvarsraw)])[-1]
names(rowvars) <- rowvarnames
rm(rowvarnames,rowvarsraw, tmp)

#### Parse column variables ####
colvarsraw[which(colvarsraw=="", arr.ind = T)] <- NA # Blanks to NAs
# Remove all-blank rows (trailing rows)
colvarsraw <- colvarsraw[rowSums(is.na(colvarsraw)) != ncol(colvarsraw), ]
# Extract unique values, which are variable values
colvars <- apply(colvarsraw, 1, function(x) unique(x[!is.na(x)]))
# Except for one-value rows, which are variable names
colvars <- colvars[lapply(colvars, length) > 1]
names(colvars) <- colvarnames
rm(colvarnames,colvarsraw)

#### CHECKS!! IMPORTANT!! #### 
# Check: size is the same?
prod(unlist(lapply(rowvars,length)))==nrow(counts)
prod(unlist(lapply(colvars,length)))==ncol(counts)
# # !! Manually check to make sure these match the order of the exported file
# expand.grid() works the opposite of ACS ordering. So, use rev(rev()).
# View(rev(expand.grid(rev(rowvars))))
# View(t(rev(expand.grid(rev(colvars)))))

#### Assigning variables to values ####
# We will use paste(..., collapse="."), so make sure there are no "."'s
unlist(colvars)[grepl(pattern = "\\.", unlist(colvars))]
colvars <- lapply(colvars, function(x) sub("\\.", "", x))

# Recall from checks: rev(rev()) matches ordering of ACS. 
names(counts) <- apply(rev(expand.grid(rev(colvars))), 1, paste, collapse=".")
messy.df <- cbind(rev(expand.grid(rev(rowvars))), counts)

# Now, use tidyr commands! 
gathered.df <- gather(messy.df, key, value, -names(rowvars))
df <- type.convert(separate(gathered.df,
                            key, into = names(colvars), sep = "\\."))

rm(colvars,counts,gathered.df,messy.df,rowvars)

# And, done!! 

# Lots of long factors, so this is MUCH smaller than write.csv:
save.image("ACS_data_cleaned.RData")
# or, export a csv. 
write.csv(x = df, 
          file = "ACS_export_cleaned.csv", 
          row.names = F)