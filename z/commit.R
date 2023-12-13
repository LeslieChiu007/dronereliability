#' @name commit
#' @title `commit.R`
#' @author Andres Garcia, Hengtao Zhao
#' @description Repository for demoing how to get the reliability of a system consisting of several components. 


# This script commits to github.
require(gert)
require(credentials)

# credentials::set_github_pat()

# Add all files changed to git commit 
gert::git_add(dir(all.files = TRUE))
# Commit all the files added, with this message.
gert::git_commit_all(message = "....")
# Push all changes to Github
gert::git_push()