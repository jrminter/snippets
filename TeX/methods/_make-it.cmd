REM batch file for jrm EK desktop
cd "C:/Data/Users/l837410/work/TeX/QM12-05-01"
pdflatex QM12-05-01
bibtex QM12-05-01
pdflatex QM12-05-01
pdflatex QM12-05-01
del *.aux *.out *.log *.toc *.b* *.lof *.lot *.nav *.snm
copy  QM12-05-01.pdf orig.pdf
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=QM12-05-01.pdf orig.pdf
del orig.pdf
pause


