# ggvisHisto.R
# Histogram with ggvis
library(ggplot2)
library(ggvis)

chol <- read.table(url("http://s3.amazonaws.com/assets.datacamp.com/blog_assets/chol.txt"), header = TRUE)

#Visualize the "AGE" column from the "chol" data frame in a simple histogram
chol %>% 
  ggvis(~AGE) %>% 
  layer_histograms()

#Visualize a histogram that takes the "AGE" column from the "chol" data set, fill the bins up with a red color and makes bins of width 5, with a zero center and add age as a title to the x-axis
chol %>% 
  ggvis(~AGE) %>%
  layer_histograms(width = 5, center = 35, fill := "#E74C3C") %>%  
  add_axis("x", title = "Age")%>%  
  add_axis("y", title = "Count")


