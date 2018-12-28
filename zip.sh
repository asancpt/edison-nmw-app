cp index.R $1.R
zip -r -ll releases/nmw-$1.zip *.R Rlib README.Rmd cover.jpg 03-EMAX 04-THEO bibliography.txt simrc Makefile
rm $1.R
rm -rf tests
mkdir tests
unzip releases/nmw-$1.zip -d tests

