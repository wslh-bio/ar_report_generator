#!/usr/bin/env R

library(rmarkdown)

rmarkdown::render("ar_report_generator.Rmd",output_file=paste0(Sys.Date(),'.ar-report.html'))
