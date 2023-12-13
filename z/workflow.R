#' @name workflow.R
#' @title Example Workflow for package functions
#' @author your names here...
#' @description Script for test workflow of package functions.

# Load functions straight from file
source("R/get_stats.R")

# Or use load_all() from devtools to load them as if they were a package
# devtools::load_all(".")

# Use default settings
get_stats()

# Or customize it by doing ....
get_stats(mot1_MTTF = 520)

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
