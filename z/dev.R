#' @name dev.R
#' @title Example Development Script for building and checking `dronereliability` package functions
#' @author Andres Garcia, Hengtao Zhao
#' @description Script for test package building of `dronereliability` package functions.


# Unload your package and uninstall it first.
unloadNamespace("dronereliability"); remove.packages("dronereliability")
# Auto-document your package, turning roxygen comments into manuals in the `/man` folder
devtools::document(".")
# Load your package temporarily!
devtools::load_all(".")


# Test out our functions
dronereliability::get_stats()

# Add 1 to x
# dronereliability::plus_one(x = 1)
# # Add 1 to a vector of x values
# dronereliability::plus_one(x = c(1,2,3,4))
# 
# # Get series system probability at each time t
# dronereliability::get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "series")
#  
# # Get parallel system probability at each time t
# dronereliability::get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "parallel")

# Just think: you could make many functions,
# outputting vectors, data.frames, ggplot visuals, etc.
# So many options!

# When finished, remember to unload the package
unloadNamespace("dronereliability"); remove.packages("dronereliability")

# Then, when ready, document, unload, build, and install the package!
# For speedy build, use binary = FALSE and vignettes = FALSE
devtools::document(".");
unloadNamespace("dronereliability");
devtools::build(pkg = ".", path = getwd(), binary = FALSE, vignettes = FALSE)


# Install your package from a local build file
# such as 
# install.packages("nameofyourpackagefile.tar.gz", type = "source")
# or in our case:
install.packages("dronereliability_0.1.0.tar.gz", type = "source")

# Load your package!
library("dronereliability")

get_stats()

# When finished, remember to unload the package
unloadNamespace("dronereliability"); remove.packages("dronereliability")

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
