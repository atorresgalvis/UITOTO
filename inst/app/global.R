##-- Packages ----
library(BiocManager)
library(Biostrings)
library(DECIPHER)
library(dplyr)
library(ggplot2)
library(readr)
library(seqinr)
library(shiny)
library(shinyjs)
library(shinyWidgets)
options(repos = BiocManager::repositories())

##-- Calling created functions ----
source("functions/utils.R")
colores <- c("#91bd0d", "#174364", "#78290F", "#FF7D00", "#f4d35e", "#15616D")


##-- Calling the components to the header of Shiny App ----
tab_files <- list.files(path = "tabs", full.names = T, recursive = T)
tab_files <- tab_files[-grep(x = tab_files, pattern = "server")]

suppressMessages(lapply(tab_files, source))
