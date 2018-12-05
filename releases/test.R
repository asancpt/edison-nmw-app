#!/SYSTEM/R/3.3.2/bin/Rscript

print("v 11:50")

## ---- IndependentChunk

# functions ---------------------------------------------------------------

Get_os <- function(){
    sysinf <- Sys.info()
    if (!is.null(sysinf)){
        os <- sysinf['sysname']
        if (os == 'Darwin')
            os <- "osx"
    } else { ## mystery machine
        os <- .Platform$OS.type
        if (grepl("^darwin", R.version$os))
            os <- "osx"
        if (grepl("linux-gnu", R.version$os))
            os <- "linux"
    }
    tolower(os)
}

###

print("Initial .libPaths() of Edison")
.libPaths()

localLibPath <- c("./lib", .libPaths())
if (Get_os()=="linux") {.libPaths(localLibPath)}
#.libPaths(.libPaths()[2])
print("Changed .libPaths() of Edison")
.libPaths()

edisonlib <- c("nmw", "lattice", "compiler", "knitr", "markdown")
lapply(edisonlib, library, character.only = TRUE) # if needed # install.packages(mylib, lib = localLibPath)
#install.packages("stringi", .lib = .libPaths()[1], repo = "http://cran.rstudio.com")

if (length(intersect(dir(), "result")) == 0) {
    system("mkdir result")
}

## ---- ArgumentChunk

# Argument ----------------------------------------------------------------

Args <- commandArgs(trailingOnly = TRUE) # SKIP THIS LINE IN R if you're testing!
if (identical(Args, character(0))) Args <- c("-inp", "data-raw/input.deck")

if (Args[1] == "-inp") InputParameter <- Args[2] # InputPara.inp

# nTheta x 2
# nEta x 1
# nEps x 1
# THETAinit x~x 10 100
# OMinit x 0.2
# SGinit x 1

inputFirst <- read.table(InputParameter, row.names = 1, sep = "=", 
                         comment.char = ";",
                         strip.white = TRUE,
                         stringsAsFactors = FALSE)
write.csv(inputFirst, "result/inputFirst.csv", row.names = TRUE)


#inputRaw <- t(input)
#rownames(inputRaw) <- c("Body Weight", 
#                        "Caffeine Dose", "Simulation Subject N", "Log Y-axis", "Plot Format", 
#                        "Multiple Dosing Interval", "Multiple Dosing")
#
#inputSummary <- inputRaw %>% data.frame() %>% 
#    rownames_to_column(var = "Input") %>% 
#    select(1, Value = 2) %>% 
#    mutate(Unit = c("kg", "mg", "", "", "", "hour", "times"))
#
#write.csv(inputSummary, "result/Data_Input.csv", row.names = FALSE)

file_doc2 <- "README"
knitr::knit(paste0(file_doc2, ".Rmd"), paste0(file_doc2, ".md"))
markdown::markdownToHTML(paste0(file_doc2, ".md"), 
                         "result/README.html", 
                         options = c("toc", "mathjax")) #, stylesheet = "mycss.css")

#browseURL("result/Report_Appendix.html")

print("Complete.")
