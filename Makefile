
all : gearshifft.pdf


%.pdf : %.tex %_references.bib
	pdflatex $*
	biber $*
	pdflatex $*
	pdflatex $*

quick : gearshifft.tex
	pdflatex $^

clean :
	rm -fv *.bbl *.blg *.aux *.bcf *.run.xml *.log *.pdf
