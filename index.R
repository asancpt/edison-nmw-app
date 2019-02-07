#!/SYSTEM/R/3.5.1/bin/Rscript
# `simrc` should contain `module load gcc/5.3.0` and `module load R/3.5.1`

options(bitmapType='cairo')
if (length(intersect(dir(), "result")) == 0) { system("mkdir result") }

if (Sys.info()['sysname'] == 'Linux') { .libPaths("./Rlib") } # for user-installed libs
library(knitr)
library(compiler)
library(lattice)
library(dplyr)
library(tidyr)
library(readr)
library(nmw)
library(optparse)

# 2. main ----

# nTheta x 2           ; number of Theta
# nEta x 1             ; number of Eta
# nEps x 1             ; number of Epsilon
# THETAinit x~x 10 100 ; Theta initial value
# OMinit x 0.2         ; Omega initial value
# SGinit x 1           ; Sigma initial value

option_list <- list(
  optparse::make_option(c("-i", "--input"), 
                        type='character', 
                        help="Input file path", 
                        default="input/ZERO.inp", 
                        metavar="character")
)

arguments <- optparse::parse_args(optparse::OptionParser(option_list=option_list), 
                                  args = commandArgs(trailing=TRUE)) %>% 
  print()

inputFirst <- read_delim(arguments$input, 
                         delim = '=', 
                         col_names = c('name', 'value')) %>%
  mutate_all(funs(trimws)) %>% 
  print()

write_csv(inputFirst, "result/inputFirst.csv")

# 3. report ----

knitr::knit2html("README.Rmd", 
                 "result/README.html", 
                 options = c("toc", "mathjax"), 
                 force_v1 = TRUE, encoding = 'UTF-8')

system("cp -rf cover.jpg figure xyplot.jpg result")

print("Complete.")

# current status

print(sapply(.libPaths(), dir))
print(capabilities())
print(sessionInfo())
