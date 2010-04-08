default:
	$(MAKE) resolve

once:
	pdflatex report.tex

# Compile twice to resolve references
resolve:
	$(MAKE) once
	$(MAKE) once

dvi:
	latex report.tex

.PHONY: clean

clean:
	rm -f *.aux *.log *.dvi *.pdf
