# demoGgpot2.R
# install.packages("ggplot2")
require(ggplot2)
require(datasets)
data(iris)
data(mtcars)

# scatterplot
p <- qplot(Sepal.Length, Petal.Width, data = iris, color = Species)
print(p)
# density plot
p <- qplot(Sepal.Length, data = iris, color = Species, geom = "density")
print(p)
# create plot objects
p <- qplot(wt, mpg, data = mtcars, color = cyl)
# to plot it
print(p)

# add layers to existing object
p <- p + layer(geom = "smooth")
print(p)