capture log close                       // closes any logs, should they be open
log using "lecture5_more_dataset_manipulation.log", replace    // open new log

// NAME: More dataset manipulation
// FILE: lecture5_more_dataset_manipulation.do
// AUTH: Will Doyle
// REVS: Benjamin Skinner
// INIT: 17 September 2014
// LAST: 15 August 2015

clear all                               // clear memory
set more off                            // turn off annoying "__more__" feature

// set globals for url data link and local data path
global urldata "http://www.ats.ucla.edu/stat/stata/library/apipop"
global datadir "../data/"
global plotdir "../plots/"

// required Ado Files: onewayplot, mdesc, mvpatterns
ssc install mdesc
ssc install onewayplot
net install dm91, from ("http://www.stata.com/stb/stb61")
                 
// check for existence of dataset
capture confirm file ${datadir}api.dta

// if there is a return code (meaning no file)...
if _rc != 0 {

    // download and save
    use $urldata, clear
    save ${datadir}api, replace
    
}
// otherwise...
else {

    // use existing dataset
    use ${datadir}api, clear
}

// create nonce datasets
preserve
collapse (mean) api99, by(cnum)
drawnorm county_inc, means(30) sds(5)
sort cnum
save ${datadir}county_data, replace
restore

preserve
collapse (mean) api99, by(dnum)
rename api99 api99c
gen edd = rbinomial(1,.3)
save ${datadir}district_data, replace
restore

// many-to-one match merging 

// sort to aid in merge
sort cnum

// merge many-to-one
merge m:1 cnum using ${datadir}county_data

// inspect merge
tab _merge
list cnum api99 county_inc if _n<10

// plot and save
onewayplot api99, by(county_inc) stack ms(oh) msize(*.1) width(1) name(api99_ow)
graph export ${plotdir}api99_ow.eps, name(api99_ow) replace

// one-to-many match merging

use ${datadir}api, clear

// sort to aid in merge
sort dnum

// save newly sorted dataset
save ${datadir}api, replace

// load nonce data
use ${datadir}district_data, clear

// sort to aid in merge
sort dnum

// merge one-to-many
merge 1:m dnum using ${datadir}api

// inspect merge
tab _merge
list dnum api99 edd if _n < 10

// messy merge

use ${datadir}api, clear

preserve
drop api00 ell mobility
sample 90
save ${datadir}api_99, replace
restore

drop api99
sample 90
save ${datadir}api_00, replace

// merge
merge snum using ${datadir}api_99, sort

// inspect merge
tab _merge

// code for looking at missing values, other patterns

// inspect command
inspect api99
inspect api00

// mdesc
mdesc api99 api00 

// mvpatterns
mvpatterns api99 api00 ell mobility

// create flag if missing ell
gen ell_flag = ell == .

// plot kernal density of api99 of observations missing ell
kdensity api99 if ell_flag == 1, ///
    name(api99_kdens) ///
    addplot(kdensity api99 if ell_flag == 0) ///
    legend(label(1 "Not Missing ELL")  label(2 "Missing ELL")) ///
    note("") ///
    title("")

graph export ${plotdir}api99_kdens.eps, name(api99_kdens) replace

// reshaping: wide to long

// read in data and sort
insheet using ${datadir}income.csv, comma clear
sort fips

// reshape long
reshape long inc_, i(fips) j(year_quarter, string)

// create date that stata understand
gen date = quarterly(year_quarter, "YQ")

// format date so we understand it
format date %tq

// list few rows
list if _n < 10

// organize data so we can graph it with xtline
xtset fips date, quarterly

// drop non-states
drop if fips < 1 | fips > 56

// graph
xtline inc_, i(areaname) t(date) name(xtline_fipsinc)
graph export ${plotdir}xtline_fipsinc.eps, name(xtline_fipsinc) replace

// reshaping: long to wide

// drop date that we added (no longer needed)
drop date

// long to wide
reshape wide inc_, i(fips) j(year_quarter, string)

// list first rows
li if _n < 10

// end file
log close                               // close log
exit                                    // exit script
