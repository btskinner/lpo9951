
// Benjamin Skinner
// LPO 9951: PhD Student Research Practicum
// Fall 2015

// QUICK NOTE RE: variance estimates of weighted means

// In the first lesson on sampling design, we discussed the use of inverse
// probability weights to compute a more accurate estimate of a
// population mean. We noted that in the class example, the estimate of
// the standard error of the mean increased. Is this always the case?
// Analytically, we would expect that our estimate of the standard error
// of the weighted mean should increase since we use more degrees of
// freedom in the process. We can also run simulations to empirically
// show this to be the case. While simulations may be sensitive to the
// data set and coding structure, they can be useful when investigating
// questions such as these.

// load fake SAT data
global datadir "../data/"
use ${datadir}fakesat, clear

// store the population mean
qui sum score
scalar fullmean = `r(mean)'

// three probabilities of reporting score
// (1) more likely as score goes up (+)
// (2) more likely as score goes down (-)
// (3) random
gen preport1 = score / 1000 + .1 * (score / 10000)^2 + rnormal(0, .025)
gen preport2 = (1 - (score / 1000)) - .1 * (score / 10000)^2 + rnormal(0, .025)
gen preport3 = runiform(0,1)

// check first column of correlations
cor score preport1 preport2 preport3

// generate inverse probability weights
gen pw1 = 1 / preport1
gen pw2 = 1 / preport2
gen pw3 = 1 / preport3

// init blank matrix to fill; for each weight (3), storing:
// unadjusted mean
// unadjusted sem
// weighted mean
// weighted sem
matrix storemat = J(100,12,.)

// run simulations...will take a few minutes
forvalues pw = 1/3 {

    // Looping through each type of pweight
    di "========================"
    di "Probability weight: pw`pw'"
    di "========================"

    // set j for matrix: needs to start at 1 and move up by 4
    local j = 4 * `pw' - 3 

    // Monte Carlo simulations with selected weight
    forvalues i = 1/100 {

        // 100 Monte Carlo runs
        di "Monte Carlo run: `i'"	  
        
        preserve

        // sample 1% using selected probability of reporting
        quietly gsample 1 [w = preport`pw'], percent

        // get unadjusted mean/sem
        quietly mean score     
        matrix est = r(table)
        matrix storemat[`i', `j'] = est[1,1]
        matrix storemat[`i', `j' + 1] = est[2,1]

        // get weighted mean/sem
        quietly mean score [pweight = pw`pw']	
        matrix est = r(table)
        matrix storemat[`i', `j' + 2] = est[1,1]
        matrix storemat[`i', `j' + 3] = est[2,1]
        
        restore
    }
}	

// drop data
drop score preport* pw*

// label the column names of the matrix
matrix colnames storemat = mean1 sem1 wmean1 wsem1 ///
                           mean2 sem2 wmean2 wsem2 ///
                           mean3 sem3 wmean3 wsem3

// convert the matrix to data in stata
svmat storemat, names(col)

// summarize all
di fullmean
sum *, sep(4)

// COMMENTS

// In all cases, we are able to estimate the true population mean
// with greater accuracy when the inverse probability weights are
// taken into account. Also note that in all cases, the standard
// error of the mean increases when weights are used. This is due to
// the variance approximation formula used by Stata. Lesson? Use weights
// to estimate a more accurate mean, but know that you pay a penalty
// in terms of your surety about the mean.

exit


