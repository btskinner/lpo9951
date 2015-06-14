capture log close                       // closes any logs, should they be open
log using "lecture0_introduction.log", replace    // open new log

// NAME: Introduction
// FILE: lecture0_introduction.do
// AUTH: Will Doyle
// REVS: Benjamin Skinner
// INIT: 20 August 2014
// LAST: 7 June 2015

clear all                               // clear memory
set more off                            // turn off annoying "__more__" feature

// using the display command for arithmetic 

display sqrt(42)

di sqrt(42) + 4

di (sqrt(42) + 4) - 10

// using do files

do "../do/lecture0_introduction_hello.do"

// comment styles

* comments can be on their own rows...
// ...like this
/* ...and this, or */

di 1           // to the
di 2           /* side of commands */

// set working directory

cd "~/Github/practicum3921/markdown"

// filename of dataset

use "../data/census.dta", clear
  
// taking a look at the data: list

list

// taking a look at the data: describe

describe

// taking a look at the data: codebook

codebook pop

// show me the data for the first ten states 

list if _n < 11

// just state names and populations for the first ten states 

li state pop if _n < 11

// recoding variables

generate poplt5_pr = poplt5 / pop

// summarize the new variable 

summarize poplt5_pr 

// summarize with more detail 

sum poplt5_pr, detail

// using the bysort command   
  
bysort region: sum poplt5_pr
  
// univariate graphics: single plot 

histogram poplt5_pr, name(h_poplt5_pr)
graph export "../plots/h_poplt5_pr.eps", name(h_poplt5_pr) replace

// univariate graphics with by command

histogram poplt5_pr, by(region) name(h_poplt5_pr_reg)
graph export "../plots/h_poplt5_pr_reg.eps", name(h_poplt5_pr_reg) replace

// kernel density plot 

kdensity poplt5_pr, name(kd_poplt5_pr)
graph export "../plots/kd_poplt5_pr.eps", name(kd_poplt5_pr) replace

// generate proportion over 65

gen pop65p_pr = pop65p / pop

// scatterplot of young population as a function of older population

graph twoway scatter poplt5_pr pop65p_pr, name(sc_poplt5_pr)
graph export "../plots/sc_poplt5_pr.eps", name(sc_poplt5_pr) replace

// add state labels

graph twoway scatter poplt5_pr pop65p_pr, ///
    msymbol(none) mlabel(state) name(sc_poplt5_pr_1)
graph export "../plots/sc_poplt5_pr_1.eps", name(sc_poplt5_pr_1) replace

// change label size

graph twoway scatter poplt5_pr pop65p_pr, ///
    msymbol(none) mlabel(state) mlabsize (tiny) name(sc_poplt5_pr_2)
graph export "../plots/sc_poplt5_pr_2.eps", name(sc_poplt5_pr_2) replace

// end file
log close                               // close log
exit                                    // exit script
