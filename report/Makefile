default:
	pdflatex report.tex

# Compile twice to resolve references
resolve:
	$(MAKE)
	$(MAKE)

dvi:
	latex report.tex

.PHONY: clean

clean:
	rm -f *.aux *.log *.dvi *.pdf
