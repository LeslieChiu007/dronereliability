#' @name workflow.R
#' @title Example Workflow for `dronereliability` package functions
#' @author Hengtao Zhao, Andres Garcia
#' @description Script for test workflow of `dronereliability` package functions.

# Load functions straight from file
source("R/get_stats.R")

# Or use load_all() from devtools to load them as if they were a package
# devtools::load_all(".")

# Use default settings, we found these values by looking at a "typical" commercial drone,
# this is meant to be a baseline, add your own data to see how reliable your drone is!
get_stats()

# Customize it by using different mean time to failure values and failure rates.
# In this example we are changing the MTTF of the original motor system to 520 hours
get_stats(mot1_MTTF = 520)
# Notice how changing the MTTF of failure for the initial motor causes all drones using this
# motor to fail at a faster rate

# Here we are changing the MTTF of the original motor to 500, of the second motor to 1000, the battery life of 
# the Lithium Ion battery system to 500, and the MTTF of the original propeller to 400 hours.
get_stats(mot1_MTTF = 520, bat1_t = 500, prop1_MTTF = 400, mot2_MTTF = 1000)
# Similiar to above, making the MTTF values smaller results in a faster failure. Depending on your system
# you can input the expected MTTF for the drone you are considering and examine it's reliability.

# We can also change the values of the other components, such as the Ground Control System's failure rate
# or the Payload System's failure rate.
get_stats(lambda_gc = .00000211, lambda_pay = 0.000011)
# The default values were found through a literary analysis, if you have a drone with different failure rates
# add their values and observe the difference!

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
