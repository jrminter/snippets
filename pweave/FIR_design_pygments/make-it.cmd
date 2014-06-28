Pweave -f tex FIR_design_pygments.Pnw
pdflatex -shell-escape FIR_design_pygments.tex
pdflatex -shell-escape FIR_design_pygments.tex
REM bibtex FIR_design_pygments.tex
REM pdflatex -shell-escape FIR_design_pygments.tex
RD /S /Q cache
RD /S /Q figures
del *.tex
del *.aux
del *.log
del *.out
del *.pyg