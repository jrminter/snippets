diag <- 42    # TV diagonal
lpf <- 1080   # lines/per frame for 1080p
x <- sqrt(diag^2/(16^2+9^2))
h <- 9*x # height of TV in inches

lpi <- x/h
lpm <- 25.4*lpi
print(sprintf("lpm = %f lines/mm", lpm))


