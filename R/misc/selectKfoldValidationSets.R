# selectKfoldValidationSets.R
# Objective: To randomly divide a large training set into K groups to
# be used to use for cross-validation of a model
#
# This function courtesy of Wojciech Sobala in response to a question
# on StackOverflow here:
# http://stackoverflow.com/questions/7402313/generate-sets-for-cross-validation-in-r
#
# note that this returns a list of K lists of two lists containg the
# indices for the sets
# Note the output from
# n <- 100
# x <- f_K_fold(n, K=5)
# print(str(x))
#
# List of 5
# $ :List of 2
# ..$ train: int [1:80] 22 36 20 89 57 47 81 76 13 30 ...
# ..$ test : int [1:20] 46 17 68 31 80 23 4 98 60 18 ...
# $ :List of 2
# ..$ train: int [1:80] 46 17 68 31 80 23 4 98 60 18 ...
# ..$ test : int [1:20] 22 36 20 89 57 47 81 76 13 30 ...
# $ :List of 2
# ..$ train: int [1:80] 46 17 68 31 80 23 4 98 60 18 ...
# ..$ test : int [1:20] 34 78 32 51 73 21 64 35 53 19 ...
# $ :List of 2
# ..$ train: int [1:80] 46 17 68 31 80 23 4 98 60 18 ...
# ..$ test : int [1:20] 28 61 96 40 26 88 77 69 5 44 ...
# $ :List of 2
# ..$ train: int [1:80] 46 17 68 31 80 23 4 98 60 18 ...
# ..$ test : int [1:20] 7 58 93 65 91 27 87 74 9 3 ...

f_K_fold <- function(Nobs,K=5){
  rs <- runif(Nobs)
  id <- seq(Nobs)[order(rs)]
  k <- as.integer(Nobs*seq(1,K-1)/K)
  k <- matrix(c(0,rep(k,each=2),Nobs),ncol=2,byrow=TRUE)
  k[,1] <- k[,1]+1
  l <- lapply(seq.int(K),function(x,k,d) 
    list(train=d[!(seq(d) %in% seq(k[x,1],k[x,2]))],
         test=d[seq(k[x,1],k[x,2])]),k=k,d=id)
  return(l)
}




