REM This should be in the ~work/prog/NAME/scripts directory
cd "../R/"
R CMD BATCH anaNozzles.R
pause
del *.Rout
del *.RData
del Rplots.pdf
del *.Rhistory

cd "../TeX/"
REM Prepare the report
pdflatex QM12-02D-05A
# bibtex QM12-02D-05A
# pdflatex QM12-02D-05A
pdflatex QM12-02D-05A
del *.aux *.out *.log *.toc *.b* *.lof *.lot
move  QM12-02D-05A.pdf QM12-02D-05A-uncomp.pdf
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=QM12-02D-05A.pdf QM12-02D-05A-uncomp.pdf 
pause

