# from http://www.r-bloggers.com/dapply-tapply-for-dataframes-a-new-r-function/
# Francis Smart 2013-05-20
#
dapply <- function(v1, index, fun, data=NULL, each=F) {
  # If a data.frame or list is defined then grab v1 and index from them.
  if (is.null(data)==F) {
    # The deparse and substitute commands together
    print(deparse(substitute(v1)))
    v1 <- data[[deparse(substitute(v1))]]
    index <- data[[deparse(substitute(index))]]
  }
  # Allow index to be a pattern in which case it is replicated accross the range of v1.
  if (length(index)<length(v1)) {
    if (length(index)*2>length(v1)) print(paste("Warning: Input vector is less than the index in length but not greater than twice."))
    # Calculate the number of replications required to duplicate the length of v1 with the index.
    ndup <- length(v1)/length(index)
    # If the number is not a whole number warn user.
    if (!is.integer(ndup)) print(gettextf("Input vector is of length %i can not be evenly divided by index of length %i.  Pattern truncated at end.", length(v1), length(index)))
    # Repeat the index as neccessary
    if (!each) index <- rep(index, times=ceiling(ndup))[1:length(v1)]
    if (each)  index <- rep(index, each =ceiling(ndup))[1:length(v1)]
  }
 
  # Calculate the vector which will be returned.
  vout <- tapply(v1, index, fun)
 
  # Expand the vout to cover multiple returns 
  returner <- NULL
  for (i in 1:length(index)) returner <- c(returner, vout[index[i]==names(vout)])
  returner
}
 
# For the vector 1:100 we will find the sum of the each block of twenty numbers.
dapply(1:100, ceiling(1:100/20),sum)
 
# We could have instead specified the index from 1:5 and by specifying each=T it tells it to multiply each element by what is neccessary to equal the length of the input vector.
dapply(1:100, 1:5, sum, each=T)
 
# Without each we will instead have the sum of all of the every fifth number.
dapply(1:100, 1:5, sum)
 
# But more in line with the uses I am looking for let's first construct a sample data frame:
district <- ceiling(1:1000/100)
stud.achievement <- rnorm(1000)+district*.1
sampleframe <- data.frame(id=1:1000, stud.achievement, district)
 
# Now let's see if we can find average student achievment by district and save it as a new variable.
sampleframe$Ave.ach <- dapply(stud.achievement, district, mean, data=sampleframe)
 
# Note, this function works very similarly to the egen command in Stata.