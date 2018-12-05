cp index.R $1.R
zip -r releases/nmw-$1.zip $1.R Rlib README.Rmd data-raw/input.deck cover.jpg 03-EMAX 04-THEO bibliography.txt simrc
rm $1.R

