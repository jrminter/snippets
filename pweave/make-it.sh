#!/bin/bash
Pweave -f tex tryPweaveExample.Pnw
pdflatex -shell-escape tryPweaveExample.tex
pdflatex -shell-escape tryPweaveExample.tex
# bibtex tryPweaveExample.tex
# pdflatex -shell-escape tryPweaveExample.tex
rm -rf cache
rm -rf figures
rm -rf *.tex
rm -rf *.aux
rm -rf *.log
rm -rf *.out
rm -rf *.pyg