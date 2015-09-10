
// Benjamin Skinner
// LPO 9951: PhD Student Research Practicum
// Fall 2015

// QUICK NOTE RE: QUANTILE CUTS USING -egen- WITH -cut-

// When discussing -egen- with -cut- in class the other day, I bumbled around
// an explanation regarding the different types of cuts one can make to
// continuous data. Hopefully this quick note will clear things up.

// header stuff    
clear all
set more off
set seed 316810

// generate fake data
set obs 1000
gen loginc = rnormal(10,1)
gen inc = exp(loginc)

// look at distribution of fake income variables
sum loginc inc
hist loginc, name(h_loginc)
hist inc, name(h_inc)

// Notice the skew of income when it isn't logged? Let's say that we want
// to categorize our income values into four groups. There are two general
// ways to do this that are based on qualitatively different ideas about
// how those groups should be created.

// (1) Equally sized bins based on the data at hand
// (2) Potentially unequal bins based on theoretically- or population-derived
//     cut points

// Neither is right or wrong in general. But the approach is important
// depending on the needs of your analyses. As I'll show below, the method
// used to cut the income variable will substantively change the way various
// values are coded.

// (1) Equally-sized bins ------------------------------------------------------

// create equal groups; show
egen inc_q = cut(inc), group(4) icodes
table inc_q

// This is what we did in class. Stata divides the distribution of income
// into four groups by setting the cuts at the 25th, 50th, and 75th percentiles.
// In this scenario, the data are assumed fixed and the cut points are
// relative to the values seen in the data.

// (2) Unequally-sized bins ----------------------------------------------------

// create unequal groups based on set cuts; show
egen inc_q2 = cut(inc), at(0,25000,50000,75000,1000000000) icodes
table inc_q2

// This approach is different. Instead of fixing the data and allowing the cut
// points to change, we instead fixed the cut points and require the data
// to bin accordingly. Notice how this time we had to include n + 1 cuts,
// where n = # of groups. This requires some knowledge about the range of the
// variable. I know that no values are below zero or above 1 billion. If not
// careful, Stata will return missing values for those that fall outside of the
// cut points.

// Why do it this second way? Perhaps your cut points are fixed by a theoretical
// framework. Or maybe you need to align categories of income in this dataset
// with those found in another. In both cases, it makes more sense to treat the
// cutpoints as fixed and the data as realizations of a random variable or
// distribution that should be binned accordingly.

// compare binning through cross table -----------------------------------------

// cross-table
table inc_q inc_q2

// Notice how we get very different categorizations. If the bins were the same,
// we should see a perfect diagonal matrix of values 250. This would mean that
// all income values coded as 0 using the first method would be 0 using the
// second method. The same would hold true for the other values.

// Instead, we have very different codings. While it seems that all the 0 values
// were coded the same by each method, the latter method also coded all formerly
// 1 values as 0 (NB: based on the way Stata creates random numbers, you may
// have slightly different results; setting the seed at the top should have
// helped, but differences may remain). The upper categories are split between
// the two methods.

// FINAL THOUGHT

// Both choices make sense within their respective contexts. The takeaway here
// is that in both situations, you have grouped a continuous variable into
// four categories. The grouping means something quite different in each case.
// Just be clear about what you are doing in your documentation/labeling.

exit
