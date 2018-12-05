#!/SYSTEM/R/3.5.1/bin/Rscript
# `simrc` should contain `module load gcc/5.3.0` and `module load R/3.5.1`

options(bitmapType='cairo')
if (length(intersect(dir(), "result")) == 0) { system("mkdir result") }

arguments <- commandArgs(trailingOnly = TRUE) 
if (identical(arguments, character(0))) { arguments <- c("-inp", "data-raw/input.deck") }
InputParameter <- arguments[2]

library(knitr)
library(compiler)
library(lattice)

if (Sys.info()['sysname'] == 'Linux') { .libPaths("./Rlib") } # for user-installed libs
library(nmw)

# current status
print(sapply(.libPaths(), dir))
print(capabilities())
print(sessionInfo())

# 2. main ----

# nTheta x 2
# nEta x 1
# nEps x 1
# THETAinit x~x 10 100
# OMinit x 0.2
# SGinit x 1

inputFirst <- read.table(InputParameter, row.names = 1, sep = "=", 
                         comment.char = ";", strip.white = TRUE, as.is = TRUE)
write.csv(inputFirst, "result/inputFirst.csv", row.names = TRUE)

# 3. report ----

knitr::knit2html("README.Rmd", 
                 "result/README.html", 
                 options = c("toc", "mathjax"), force_v1 = TRUE)

system("cp cover.jpg xyplot.jpg result")

print("Complete.")

