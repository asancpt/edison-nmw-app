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

# 2. main ----

# nTheta x 2           ; number of Theta
# nEta x 1             ; number of Eta
# nEps x 1             ; number of Epsilon
# THETAinit x~x 10 100 ; Theta initial value
# OMinit x 0.2         ; Omega initial value
# SGinit x 1           ; Sigma initial value

input_deck <- 'Dataset = Theoph
Method = ZERO
nTheta = 3
nEta = 3
nEps = 2
THETAinit = 2, 50, 0.1
OMinit = 0.2, 0.1, 0.1, 0.1, 0.2, 0.1, 0.1, 0.1, 0.2
SGinit = 0.1, 0, 0, 0.1'

arguments <- commandArgs(trailingOnly = TRUE)
if (length(arguments) == 0) { arguments <- c("-inp", input_deck, "-file", "NCAResult4BE.csv") }

table_args <- matrix(arguments, ncol = 2, byrow = TRUE) %>%
  as_tibble() %>%
  mutate(V1 = sub('-', '', V1)) %>%
  spread(V1, V2) %>%
  print()

inputFirst <- read_delim(table_args$inp, 
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

