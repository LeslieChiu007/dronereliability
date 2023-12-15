# Drone Reliability
- **Description**: Repository for simulating the reliability of a commercial drone to analyze how different components play a role in overall system reliability!
- **Authors**: Andres Garcia and Hengtao Zhao 

## How to Install Our Package

```r
# Install from devtools, using dependencies!
devtools::install_github("LeslieChiu007/dronereliability", dependencies = TRUE)

library(dronereliability)
dronereliability::get_stats()
```

## 1. DESCRIPTION

```r
Package: dronereliability
Version: 0.1.0
Date: 2023-12-13
Title: Drone Reliability
Authors@R: c(
  person("Zhao", "Hengtao", email = "hz298@cornell.edu", role = c("aut", "cre")),
  person("Garcia", "Andres", email = "@cornell.edu", role = c("aut", "cre"))
  )
Author: Hengtao Zhao [aut, cre],
  Andres Garcia [aut],
Maintainer: Hengtao Zhao <hz298@cornell.edu>
Description: Analyze the expected reliability of a drone after 1000 hours by inputting failure rates for different components
License: MIT + file LICENSE
Encoding: UTF-8
LazyData: true
Rxoygen: list(markdown = TRUE)
RoxygenNote: 7.2.3
Depends: R (>= 3.5.0)
Imports:
    dplyr,
    ggplot2
    
```

## 3. Overview

```r
# This function will calculate the reliability of a commercial drone system.
# It splits a commercial drone into six different systems: Ground Control,
# Mainframe, Power System, Payload, Electronics System, and Navigation Systems.
# We further broke down the Power System into 3 main components, the battery,
# motors, and propellers. The failure rates for the 6 systems were derived from
# literary research and the mean time to failure of the batteries, motors, and
# propellers were found by using the most common commercial options. 
# 
# Throughout this analysis we are making some key assumptions:
# - Failure is only a result of internal components failing, not human error or weather
# - Drones have 6 propellers
# - Changing components doesn't directly change others
# - 1000 flight hours in one year
# - The Power System only fails because of motors, propellers, and it's battery system
#
#
# The MTTF for the original motor and propellers (mot1 and mot2) are the lower ends
# of the ranges that we found online for drone motors and propellers. The MTTF for
# the improved motors and propellers, (mot2 and prop2) are the higher ends of the 
# ranges that we found online. Using these values, we are comparing the reliability
# as a result of using higher quality components. In this function you are free to
# enter your own MTTF for intitial and final motor/battery components and observe
# how this affects a drone's reliability.
#
# For the batteries, our initial battery component (bat1) is a lithium ion battery
# system. We found its MTTF by multiplying the average lifetime of one cycle (bat1_t)
# by the expected cycles until failure for the system. For our second battery system,
# we used NiMH batteries as they were observed to be more reliable. We used th same approach
# as above with the average lifetime and expected cycles to find it's MTTF. You are free to
# input any values to compare the effects that battery systems have in the reliabiliy of commercial
# drones.
# 
# The failure rates (lambda) for the remaining 5 components were identified through
# literary research and their values set as the default. Once again, you can input different
# values in order to see how these components affect the reliability of a commercial drone system.
# 
# The function uses these inputs to find the reliability of each component, and then
# uses these values to run a binomial simulation at each time interval. The function
# then finds the average, standard deviation, and standard error at each interval. It then plots
# the average values as well as an upper and lower bound with a 95% confidence interval. The four
# plots are the reliability of the original system, using a new motor, using a new battery system,
# using a new propeller, and using a new motor, battery, and propeller at the same time.
# 
# It then outputs the estimated reliability for each observed scenario at 1 year.
```

## 2. Workflow

```r
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
```