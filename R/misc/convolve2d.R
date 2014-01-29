# convolve2d.R
# test 2-d convolution from Romain Francoise in response to Hadley Wickham
# here:
# http://www.digipedia.pl/usenet/thread/14655/4083/#post4083
#
# fix archectecture issue with first line from
# http://support.rstudio.org/help/discussions/problems/3120-i386x86_64-conflicts-in-libraries-on-mac-os-x-106-with-rstudio
#
# On macbook I got
#    user  system elapsed 
#   0.566   0.000   0.567
#
Sys.setenv(R_ARCH="/x86_64")
require(inline)
# 2d convolution
convolve_2d_tricks <- cxxfunction(signature(sampleS = "numeric",
                                            kernelS = "numeric"),
																	plugin = "Rcpp", '
  Rcpp::NumericMatrix sample(sampleS), kernel(kernelS);
  int x_s = sample.nrow(), x_k = kernel.nrow();
  int y_s = sample.ncol(), y_k = kernel.ncol();

  Rcpp::NumericMatrix output(x_s + x_k - 1, y_s + y_k - 1);
  double* output_row_col_j ;
  double sample_row_col = 0.0 ;
  double* kernel_j ;


  for (int row = 0; row < x_s; row++) {
    for (int col = 0; col < y_s; col++) {
      sample_row_col = sample(row,col) ;
			for (int j = 0; j < y_k; j++) {
        output_row_col_j = & output( row, col+j ) ;
        kernel_j = &kernel(0,j) ;
        for (int i = 0; i < x_k; i++) {
          output_row_col_j[i] += sample_row_col * kernel_j[i] ;
        }
      }
    }
  }
  return output;
')

x<- diag(1000)
k<- matrix(runif(20* 20), ncol = 20)
print(system.time(convolve_2d_tricks(x, k)))

