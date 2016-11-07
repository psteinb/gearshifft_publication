#!/usr/bin/env Rscript

library(docopt)


library(ggplot2)
library(readr)
library(dplyr)


'Usage:
   dual_compare.R [options] <csv-files>...

 -r --real          Use Real Data [default: FALSE]
 -c --complex       Use Complex Data [default: FALSE]
 -i --inplace       Use inplace transforms [default: FALSE]
 -o --outofplace    Use out-of-place transforms [default: FALSE]
 -s --fp32          Use (32-bit) single precision [default: FALSE]
 -d --fp64          Use (64-bit) double precision [default: FALSE]
 -n --ndims=ND      Use only ND dimensional output [default: 3]
' -> doc

opts <- docopt(doc)
#str(opts)

gearshifft_data <- read_csv(opts[["<csv-files>"]][1],skip=4,col_names=TRUE)
head(gearshifft_data)
length(gearshifft_data)
nrow(gearshifft_data)

