# demotool
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
Description: One-line description for package goes here. Make sure this script ends with an extra blank line after `Imports:`
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

# Use default settings
get_stats()

# Or customize it by using different mean time to failure values and failure rates.
# In this example we are changing the MTTF of the original motor system to 520 hours
get_stats(mot1_MTTF = 520)

# Here we are changing the MTTF of the original motor to 500, of the second motor to 1000, the battery life of 
# the Lithium Ion battery system to 500, and the MTTF of the original propeller to 400 hours.
get_stats(mot1_MTTF = 520, bat1_t = 500, prop1_MTTF = 400, mot2_MTTF = 1000)

# We can also change the values of the other components, such as the Ground Control System's failure rate
# or the Payload System's failure rate.
get_stats(lambda_gc = .00000211, lambda_pay = 0.000011)

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
```