#!/usr/bin/env Rscript

library(rmarkdown)
library(argparser)

# Get command line arguments
parser <- arg_parser("Automated AR Report Builder")

#position args
parser <- add_argument(parser, "projectname", help="set name of project")
parser <- add_argument(parser, "username", help="name of report preparer")
parser <- add_argument(parser, "summary_text", help="text file with summary text")
parser <- add_argument(parser, "sampletable", help="csv/tsv of sample information")

#optional args
parser <- add_argument(parser, "--date", default=Sys.Date(), help="set date of report, default: current date")
parser <- add_argument(parser, "--snpmatrix", help="csv/tsv of snp data")
parser <- add_argument(parser, "--tree", help="tree data")
parser <- add_argument(parser, "--artable", help="ar data")
parser <- add_argument(parser, "--additionaldatatables", help="", nargs=Inf)

argv <- parse_args(parser)

# read inputs

## set header text
if("snpmatrix" %in% names(argv) | "tree" %in% names(argv)  & "artable" %in% names(argv)) {
  subHeaderText = "Antimicrobial Resistance Outbreak Report"
} else if ("snpmatrix" %in% names(argv) | "tree" %in% names(argv)  & !"artable" %in% names(argv)){
  subHeaderText = "Outbreak Report"
} else (
  subHeaderText = "Antimicrobial Resistance Report"
)

## get header table
headerDF <- data.frame(date=argv$date,project=argv$projectname,name=argv$username)

## get summary text
summaryTEXT <- paste(readLines(argv$summary_text), collapse="\n")

## get sample table
if(grepl(".tsv", argv$sampletable)){
  sampleDF <- read.csv2(argv$sampletable,sep='\t')
} else if(grepl(".csv", argv$sampletable)) {
  sampleDF <- read.csv2(argv$sampletable,sep=',')
} else {
  print('Sample table must be in csv/tsv format.')
  quit(save="no", status=1)
}

## get optional heatmap
if("snpmatrix" %in% names(argv)){
  if(grepl(".tsv", argv$snpmatrix)){
    snpData <- read.csv2(argv$snpmatrix,sep='\t')
  } else if(grepl(".csv", argv$snpmatrix)) {
    snpData <- read.csv2(argv$snpmatrix,sep=',')
  } else {
    print('SNP data must be in csv/tsv format.')
    quit(save="no", status=1)
  }
}

## get optional tree
if("tree" %in% names(argv)){
  treepath <- argv$tree
}


rmarkdown::render("ar_report_generator.Rmd",output_file=paste0(Sys.Date(),'.ar-report.html'))
