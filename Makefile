run:
	rm -rf results ;\
	Rscript index.R

run-cond:
	rm -rf results ;\
	Rscript index.R -i input/CONC.inp

run-lapl:
	rm -rf results ;\
	Rscript index.R -i input/LAPL.inp

github:
	Rscript -e "rmarkdown::render('README.Rmd', output_format = 'github_document')"

pdf:
	Rscript -e "rmarkdown::render('README.Rmd', output_format = 'pdf_document')"

html:
	Rscript -e "rmarkdown::render('README.Rmd', output_format = 'html_document')"

bib:
	Rscript -e "rmarkdown::render('bibliography.Rmd', output_format = 'html_document')"

