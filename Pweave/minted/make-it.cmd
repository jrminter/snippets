Pweave -f  texminted minted.Pnw
pdflatex -shell-escape minted.tex
pdflatex -shell-escape minted.tex
REM bibtex minted.tex
REM pdflatex -shell-escape minted.tex
RD /S /Q cache
RD /S /Q figures
del *.tex
del *.aux
del *.log
del *.out
del *.pyg