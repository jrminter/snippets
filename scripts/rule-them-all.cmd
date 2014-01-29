REM This should be in the ~work/prog/NAME/scripts directory
cd "../R/"
R CMD BATCH myCode.R
pause
del *.Rout
del *.RData
del Rplots.pdf
del *.Rhistory

cd ../Sweave/
R CMD Sweave  myRept
REM R CMD Stangle myRept
pdflatex myRept
bibtex myRept
pdflatex myRept
pdflatex myRept
del *.aux
del *.dvi
del *.log
del *.tex
del *.toc
del *.blg
del *.bbl
del *.brf
del *.lo*
del myRept-*.*
del Rplots.pdf
del .Rhistory
REM move /Y myRept.R ../R/

move  myRept.pdf myRept-uncomp.pdf
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=myRept.pdf myRept-uncomp.pdf
del *.out
del *.snm
del *.nav
del *-uncomp.pdf
 
pause

