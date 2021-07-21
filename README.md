# useful R code
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
> tab <- table(data.frame(lower = sample(letters[1:5], size = 100, replace = T),
+                         upper = sample(LETTERS[1:5], size = 100, replace = T)))
> tab
     upper
lower A B C D E
    a 5 1 4 4 3
    b 2 5 6 5 5
    c 2 4 3 2 5
    d 6 2 4 7 5
    e 3 4 4 3 6
> class(tab)
[1] "table"
> as.matrix.table(tab)
     upper
lower A B C D E
    a 5 1 4 4 3
    b 2 5 6 5 5
    c 2 4 3 2 5
    d 6 2 4 7 5
    e 3 4 4 3 6
> class(as.matrix.table(tab))
[1] "matrix" "array" 
```

`duplicates.R` contains three functions to get both duplicate observations, and the observation of which they are duplicates (i.e., the intersection of `duplicated()` and `duplicated(fromLast=T)`, which is also how I actually do it; not the most efficient but it's very lightweight). This is useful, for example, for comparing rows that are duplicated according to some subset of columns, to see why they are not complete duplicates of each other across all columns. `duplicates()` returns all of a set of duplicate observations, `which.duplicates()` gives the row indexes, and `View.duplicates()` opens a `View()` window of the duplicates for exploration. 
