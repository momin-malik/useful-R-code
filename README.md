# useful-R-code
Some useful R functions I've made. These are unfinished in terms of testing and finessing, but usable and hopefully useful for others. 

`ACS_import.R` is a script to import "Public Use Microdata Sample" (PUMS) from the US Census Bureau's American Community Survey, as outputed as "export.csv" by the MDAT tool (https://data.census.gov/mdat/). See disclaimers within the file. 

`ccdf.R` makes complementary [empirical] cumulative density function plots, the best practice for plotting long-tailed distributions as recommended in Aaron Clauset, Cosma Rohilla Shalizi, and Mark E. J. Newman, "Power-law distributions in empirical data," _SIAM Review_ 51, No. 3 (2009): 661-703. [doi: 10.1137/070710111](https://dx.doi.org/10.1137/070710111).
![ccdf](https://raw.githubusercontent.com/momin-malik/useful-R-code/master/ccdf_example.png)

`igraph_triad_census_plot.R` makes triad census dotplots using the actual triad subgraphs as labels, using the `igraph` package. 
![igraph_triad_census_plot](https://raw.githubusercontent.com/momin-malik/useful-R-code/master/igraph_triad_census_plot_example2.png)

`network_triad_census.R` does the same thing but using the `network` and `sna` packages. 

`ptable.R` is a function that makes STATA-like contingency tables, showing both counts and percentages for column marginals, like such:

```
               1st        2nd        3rd         Total      
Didn't Survive 80 (37%)   97 (52.7%) 372 (75.8%) 549 (61.6%)
Survived       136 (63%)  87 (47.3%) 119 (24.2%) 342 (38.4%)
Total          216 (100%) 184 (100%) 491 (100%)  891 (100%)
```


`as.matrix.table` is a one-line function that should really be built-in in R but isn't: it converts a table to a matrix with the same dimensions (and dimension names, and row/column names) as the printout of the table. 
```
> tab <- table(data.frame(lower = sample(letters[1:10], size = 1000, replace = T),
+                         upper = sample(LETTERS[1:10], size = 1000, replace = T)))
> tab
     upper
lower  A  B  C  D  E  F  G  H  I  J
    a  9  9 14 11 12 15  5 10 10 10
    b  6  9 12 14 10  6 13  6  9 12
    c  7 14  8  8  9  4  9 11 14  4
    d  9 11  6 13 18 10 10  8  7  8
    e  8  7 14  7 10 12 13  7 11 10
    f  9  9  4 11  8  7  8  9 15  8
    g  6  8  9 11  7 10 14  9 11  7
    h 13 17 13  7  8 13 10  8 12 10
    i 14 12 10 11 13 15  9 12  7 15
    j 14 10 11 11  7 10 14  7 11  7
> class(tab)
[1] "table"
> as.matrix.table(tab)
     upper
lower  A  B  C  D  E  F  G  H  I  J
    a  9  9 14 11 12 15  5 10 10 10
    b  6  9 12 14 10  6 13  6  9 12
    c  7 14  8  8  9  4  9 11 14  4
    d  9 11  6 13 18 10 10  8  7  8
    e  8  7 14  7 10 12 13  7 11 10
    f  9  9  4 11  8  7  8  9 15  8
    g  6  8  9 11  7 10 14  9 11  7
    h 13 17 13  7  8 13 10  8 12 10
    i 14 12 10 11 13 15  9 12  7 15
    j 14 10 11 11  7 10 14  7 11  7
> class(as.matrix.table(tab))
[1] "matrix" "array"
```
