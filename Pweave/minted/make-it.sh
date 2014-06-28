#!/bin/bash
Pweave -f texminted minted.Pnw
pdflatex -shell-escape minted.tex
pdflatex -shell-escape minted.tex
# bibtex minted.tex
# pdflatex -shell-escape minted.tex
rm -rf cache
rm -rf figures
rm -rf *.tex
rm -rf *.aux
rm -rf *.log
rm -rf *.out
rm -rf *.pyg