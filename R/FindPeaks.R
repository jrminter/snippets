# FindPeaks.R
#
# from http://www.reddit.com/r/tinycode/comments/x1mto/finding_the_peaks_in_a_time_series_with_r/
# Find peaks in a series - written by Brian Ripley
# Most of the trickiness involves the embed() function
# and the integer division in the next line. 
peaks<-function(series, span = 3) { 
z <- embed(series, span) 
s <- span%/%2 
v<- max.col(z) == 1 + s 
result <- c(rep(FALSE, s), v) 
return(result[1:(length(result) - s)])
} 
