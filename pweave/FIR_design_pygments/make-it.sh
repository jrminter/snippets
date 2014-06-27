#!/bin/bash
Pweave -f tex FIR_design_pygments.Pnw
pdflatex -shell-escape FIR_design_pygments.tex
pdflatex -shell-escape FIR_design_pygments.tex
# bibtex FIR_design_pygments.tex
# pdflatex -shell-escape FIR_design_pygments.tex
rm -rf cache
rm -rf figures
rm -rf *.tex
rm -rf *.aux
rm -rf *.log
rm -rf *.out
rm -rf *.pyg