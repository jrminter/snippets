# Fix data frame
# inspired by climate change example
# see http://www.r-bloggers.com/get-historical-climate-data-from-knmi-climate-explorer/

fix.climate.data <- function(df, na.code=-999.9)
{
  mat <- as.matrix(df)
  mat[mat == na.code] <- NA
  res <- as.data.frame(mat)
  mat
}

# get climate (precipitation) data from url:
# http://climexp.knmi.nl/selectstation.cgi?id=someone@somewhere
# read the insbruck data
ibk_dat <- read.table("http://climexp.knmi.nl/data/pa11120.dat", sep = "", 
                      row.names = 1, col.names = 0:12)
# fix the insbruk data
fixed <- fix.climate.data(ibk_dat, na.code=-999.9)
colnames(fixed) <- c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
print(head(fixed))
x <- as.numeric(rownames(fixed))
y <- rowMeans(fixed, na.rm=T)

plot(x,y)

hist(y)



