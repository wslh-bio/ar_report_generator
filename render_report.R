#!/usr/bin/env Rscript

library(rmarkdown)
library(argparser)
library(yaml)

# Get command line arguments
parser <- arg_parser("Automated AR Report Builder")

#position args
parser <- add_argument(parser, "projectname", help="set name of project")
parser <- add_argument(parser, "username", help="name of report preparer")
parser <- add_argument(parser, "sampletable", help="csv/tsv of sample information")
parser <- add_argument(parser, "config", help="report configuration file")

#optional args
parser <- add_argument(parser, "--date", default=Sys.Date(), help="set date of report, default: current date")
parser <- add_argument(parser, "--snpmatrix", help="csv/tsv of snp data")
parser <- add_argument(parser, "--tree", help="tree data")
parser <- add_argument(parser, "--cgstats", help="prokka cg stats 'core_genome_statistics.txt'")
parser <- add_argument(parser, "--artable", help="ar data")
parser <- add_argument(parser, "--additionaldatatables", help="", nargs=Inf)

argv <- parse_args(parser)

# read yaml file
config <- read_yaml(argv$config)

## set header text
subHeaderText = config$sub.title
## get header table
headerDF <- data.frame(date=argv$date,project=argv$projectname,name=argv$username)
## get summary text
summaryTEXT <- config$summary.paragraph
## get disclaimer text
disclaimerTEXT <- config$disclaimer.text
## get methods text
methodsTEXT <- config$methods.text

## get sample table
if(grepl(".tsv", argv$sampletable)){
  sampleDF <- read.csv2(argv$sampletable,sep='\t')
} else if(grepl(".csv", argv$sampletable)) {
  sampleDF <- read.csv2(argv$sampletable,sep=',')
} else {
  print('Sample table must be in csv/tsv format with a .tsv or .csv extension.')
  quit(save="no", status=1)
}

## get optional heatmap
if(!is.na(argv$snpmatrix)){
  if(grepl(".tsv", argv$snpmatrix)){
    snpData <- read.csv2(argv$snpmatrix,sep='\t')
  } else if(grepl(".csv", argv$snpmatrix)) {
    snpData <- read.csv2(argv$snpmatrix,sep=',')
  } else {
    print('SNP data must be in csv/tsv format with a .tsv or .csv extension.')
    quit(save="no", status=1)
  }
}

## get optional tree
if(!is.na(argv$tree)){
  treepath <- argv$tree
}

## get optional cgstats
if(!is.na(argv$cgstats)){
  cgstats <- read.csv2(argv$cgstats,sep='\t',header = FALSE)
}

## get optional ar-summary
if(!is.na(argv$artable)){
  if(grepl(".tsv", argv$artable)){
    ar_summary <- read.csv2(argv$artable,sep='\t')
  } else if(grepl(".csv", argv$artable)) {
    ar_summary <- read.csv2(argv$artable,sep=',')
  } else {
    print('AR data must be in csv/tsv format with a .tsv or .csv extension.')
    quit(save="no", status=1)
  }
}

## get optional additional data tables
if(!is.na(argv$additionaldatatables)){
  optionalData <- list()
  for (df_path in argv$additionaldatatables){
    if(grepl(".tsv", df_path)){
      df <- read.csv2(df_path,sep='\t')
    } else if(grepl(".csv", df_path)) {
      df <- read.csv2(df_path,sep=',')
    } else {
      print('Additional data must be in csv/tsv format with a .tsv or .csv extension.')
      quit(save="no", status=1)
    }
    optionalData[[length(optionalData)+1]] <- df
  }
}

rmarkdown::render("ar_report_generator.Rmd",output_file=paste0(Sys.Date(),'.ar-report.html'))
