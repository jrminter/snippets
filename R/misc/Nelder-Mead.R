func <- function(x){
  out <- (x[1]-2)^2 + (x[2]-1)^2
  return <- out
}

optim(par=c(0,0), fn=func, gr = NULL,
      method = c("Nelder-Mead"),
      lower = -Inf, upper = Inf,
      control = list(), hessian = T)
