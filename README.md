# useful-R-code
Some useful R functions I've made. These are unfinished in terms of testing and finessing, but usable and hopefully useful for others. 

`ccdf.R` makes complementary [empirical] cumulative density function plots, the best practice for plotting long-tailed distributions as recommended in Aaron Clauset, Cosma Rohilla Shalizi, and Mark E. J. Newman, "Power-law distributions in empirical data," _SIAM Review_ 51, No. 3 (2009): 661-703. [doi: 10.1137/070710111](https://dx.doi.org/10.1137/070710111).
![ccdf](https://raw.githubusercontent.com/momin-malik/useful-R-code/master/ccdf_example2.png)

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
