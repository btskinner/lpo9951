---
layout: default
title: Notes
date: LPO 9951 | Fall 2015
author: Benjamin Skinner
---

# Notes

From time to time, there will be questions in class that I cannot
answer in the moment. It may that there isn't enough time or, equally
likely, that I've managed to confuse even myself and
need some time to formulate a useful answer. Hopefully the notes
below will clarify some issues that have arisen in class this
semester.

## Binning a continuous variable

When splitting a continuous variable into groups, it makes a
difference whether you think the distribution is fixed and the cut
points should vary depending on the percentile value or you believe
that the cuts should be fixed and that the values of the continuous
variable should fall into bins according to those cuts. The following
do file shows how to cut a continuous variable both ways and the
difference that the choice in procedure makes for how observations are
grouped.

#### FILE

[quantilenote.do](https://raw.githubusercontent.com/btskinner/lpo9951/master/notes/quantilenote.do)

## Using `erase` to remove files

If you choose to store a large dataset in zipped form, only expanding
it when you wish to subset parts of it for your analysis, it does not
make sense to keep the fully expanded version in your directory as
well. In [lecture 3](http://btskinner.me/lpo9951/schedule/) we
discussed how to unzip, subset, and save reduced NCES data files. The
code did not include the final step of erasing the expanded file. The
following do file, along with the accompanying zip file, shows you how
to incorporate this last step. Be aware, however, that Stata's `erase`
command is permanent and work with caution.

NOTE: Unlike in class, the do file and zipped data file should placed
in the same directory.  

#### FILES

[erasenote.do](https://raw.githubusercontent.com/btskinner/lpo9951/master/notes/erasenote.do)  
[erasenote_data.zip](https://raw.githubusercontent.com/btskinner/lpo9951/master/notes/erasenote_data.zip)

## Variance estimates of inverse weighted means

In the first lesson on sampling design, we discussed the use of inverse probability weights to compute a more accurate estimate of a population mean. We noted that in the class example, the estimate of the standard error of the mean increased. Is this always the case?


#### FILES

[weightsnote.do](https://raw.githubusercontent.com/btskinner/lpo9951/master/notes/weightsnote.do)  


 