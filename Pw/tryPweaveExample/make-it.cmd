Pweave -f tex tryPweaveExample.Pnw
pdflatex -shell-escape tryPweaveExample.tex
pdflatex -shell-escape tryPweaveExample.tex
REM bibtex tryPweaveExample.tex
REM pdflatex -shell-escape tryPweaveExample.tex
RD /S /Q cache
RD /S /Q figures
del *.tex
del *.aux
del *.log
del *.out
del *.pyg