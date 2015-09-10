
// Benjamin Skinner
// LPO 9951: PhD Student Research Practicum
// Fall 2015

// QUICK NOTE RE: using the -erase- command

// As some of you rightly noted during our 3rd lecture, it doesn't make
// much sense to keep both the zipped and unzipped versions of a large
// data file on your machine. In interest of saving hard drive space and
// future portability, we should probably keep the zipped version. But if
// we are going to do that, we should remove the full dataset after we
// have unzipped it, loaded the variables we want, and saved our reduced
// file.

// The command for removing a file is -erase- or -rm-, the latter of which
// Unix people familiar with the command line are accustomed to using. The
// commands below follow the same data loading workflow we used in class
// with the addition that we delete the unzipped master file at the end.

// STEPS

// (1) Unzip master file (erasenote_data.zip)
// (2) read in data using only the vars we want (erasenote_data.dta)
// (3) save new reduced dataset (erasenote_data_reduced.dta)
// (4) erase full dataset (*.dta), keeping zipped version (*.zip)

// WARNING /////////////////////////////////////////////////////////////////////

// -erase-/-rm- performs a permanent action. Erased files are not moved to
// the Trash or Recycling Bin. They are gone. Forever. For-ev-ver. So be sure
// you know exactly which file you are erasing before you do so.

// To keep things simple, and thereby reduce the chance of catastrophic error,
// this script assumes that the data and do files are in the same directory.
// Adding the directory paths as we have done in class is easy enough to do.

// /////////////////////////////////////////////////////////////////////////////

// RUN -------------------------------------------------------------------------

// set globals
global zipdata "erasenote_data.zip"     // the zipped file
global alldata "erasenote_data.dta"     // the full Stata data file
global savdata "erasenote_data_reduced" // the reduced Stata data file

// unzip the dataset
unzipfile $zipdata

// NB: erasenote_data.dta has "id" variable + "a" - "z" variables

// change delimiter
#delimit ;

// read in data keeping id and a-f vars
use
  id
  a
  b
  c
  d
  e
  f
using $alldata, clear;

// change delimiter back
#delimit cr

// save reduced data
save $savdata, replace

// erase full dataset, keeping zipped version
erase $alldata

// close
exit
