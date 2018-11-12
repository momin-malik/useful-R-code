# useful-R-code
Some useful R functions I've made.

`ccdf.R` makes plots like this:
![ccdf](https://raw.githubusercontent.com/momin-malik/useful-R-code/master/ccdf_example2.png)

`igraph_triad_census_plot.R` makes plots like this:
![igraph_triad_census_plot](https://raw.githubusercontent.com/momin-malik/useful-R-code/master/igraph_triad_census_plot_example2.png)

`network_triad_census.R` does the same thing but using the `network` and `sna` packages. 

`ptable.R` is a function that makes STATA-like contingency tables, showing both counts and percentages for column marginals, like such:
`               1st        2nd        3rd         Total      
Didn't Survive 80 (37%)   97 (52.7%) 372 (75.8%) 549 (61.6%)
Survived       136 (63%)  87 (47.3%) 119 (24.2%) 342 (38.4%)
Total          216 (100%) 184 (100%) 491 (100%)  891 (100%)` 
