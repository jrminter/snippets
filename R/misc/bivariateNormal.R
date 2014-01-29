# bivariateNormal.R
require(rgl)
require(MASS)
gaussCurve <- function() { 
  # parameters
  n <- 50
  ngrid <- 40
  
  # generate samples
  set.seed(31415)
  x <- rnorm(n)
  y <- rnorm(n)
  
  # estimate non-parameteric density surface via kernel smoothing
  denobj <- kde2d(x, y, n = ngrid)
  den.z <-denobj$z
  
  # generate parametric density surface of a
  # bivariate normal distribution
  xgrid <- denobj$x
  ygrid <- denobj$y
  bi.z <- dnorm(xgrid) %*% t(dnorm(ygrid))
  
  # visualize
  zscale <- 20
  
  # clear scene
  clear3d()
  clear3d(type = "bbox")
  clear3d(type = "lights")
  
  # setup env
  bg3d(color = "white")
  light3d()
  
  # Draws parametric density
  surface3d(xgrid,
            ygrid, bi.z * zscale,
            color = "yellow", front = "lines",
            back = "cull")
}
gaussCurve()
# rgl.bg(sphere = TRUE, texture = "Rlogo-4.png", back = "filled" )
