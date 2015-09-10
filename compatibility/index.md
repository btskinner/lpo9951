---
layout: default
title: Compatibility Issues
date: LPO 9951 | Fall 2015
author: Benjamin Skinner
---

# Compatibility Issues

The content for this course was produced using Apple's OS X. For most of what
we do, your choice of computer system is irrelevant. Stata is
cross-platform and is generally agnostic or self correcting when it
comes to the differences between Unix and Windows systems.

There are some differences that arise from time to time, however, that
can stall code when moved across platforms. Most often this will occur
when we use Stata to navigate the underlying file system: `cd`,
`confirm`, `erase`, etc.  This page will attempt to document the
discrepancies as they arise in class and offer solutions.

*Note to Linux users: As a member of the *nix family, your
distribution is likely to work just fine with Stata code written with
OS X in mind. As a Linux user, you probably already knew that.*

## Forward slash (`/`) vs. backslash (`\`)

### Problem

Whereas Unix systems use the forward slash (`/`) in its directory
structures:

```
~/dofiles/example_file.do
```

Windows makes use of the backslash (`\`):

```
C:\dofiles\example_file.do
```

The problem with the backslash is that it is used as one of a number of
escape characters by Stata. This means that it has a special meaning
in some situations that changes how Stata interprets it.

For the most part, Stata can handle either forward- or backward
slashes in directory paths. The
[Stata Journal (8/3, 446-447)](http://www.stata-journal.com/sjpdf.html?articlenum=pr0042#4)
tells us that

> Stata takes it upon itself to translate between you and the
operating system....A backslash is only problematic whenever it can be
interpreted as an escape character. In fact, you can mix forward and
backward slashes willy-nilly in directory or filenames within Stata
for Windows...

*except* when that backslash comes before a character, such as a
backtick `` ` ``, that Stata is accustomed to treating in its own
special fashion (as the beginning of a local macro, for example), but now
interprets as normal character escaped with the backslash.

### Example

As a concrete example that has occurred in class, the following code

```
global datadir "C:\practicum\data\"
global dataset "dataset.dta"

use $datadir$dataset
```

will not correctly expand and concatenate the globals into
`C:\practicum\data\dataset.dta` but rather will return
`C:\practicum\data$dataset`. This is because the trailing backslash on
the `$datadir` macro will escape the `$` on the `$dataset` macro,
causing Stata to interpret it literally and, because it doesn't
expand, crash the code.

### Fix

There are a couple of fixes here. First, you can double backslash
throughout your directory structures like so:

```
C:\\dofiles\\example_file.do
```

This works because Stata interprets the first backslash as an escape
character and then includes the second as is. Therefore, all
`\\` turn into `\`.

Second, you can follow the advice of the Stata Journal:

> The tidiest solution is to use forward slashes
consistently...although admittedly this may clash strongly with your
long-practiced Windows habits.

That means writing all your directory paths like this:

```
C:/dofiles/example_file.do
```

You won't be able to simply cut and paste from your computer file
system into Stata, but if you do it once and store it in a global or
local macro, you're set for the rest of the script.


 
