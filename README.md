# AR Report Generator

AR Report Generator is an R script used to render a report from the output of pipelines that examine prokaryote relatedness in outbreaks e.g. [Dryad](https://github.com/wslh-bio/dryad). AR Report Generator uses Rmarkdown and Plotly to generate an interactive html document.

## Usage

Running the report generator using 'Rscript render_report.R' provides a menu of options:

```
usage: render_report.R [--] [--help] [--opts OPTS] [--date DATE]
       [--snpmatrix SNPMATRIX] [--tree TREE] [--cgstats CGSTATS]
       [--artable ARTABLE] [--additionaldatatables
       ADDITIONALDATATABLES] projectname username sampletable config

Automated AR Report Builder

positional arguments:
  projectname             set name of project
  username                name of report preparer
  sampletable             csv/tsv of sample information
  config                  report configuration file

flags:
  -h, --help              show this help message and exit

optional arguments:
  -d, --date              set date of report, default: current date
  -s, --snpmatrix         csv/tsv of snp data
  -t, --tree              tree data
  -c, --cgstats           roary cg stats 'core_genome_statistics.txt'
  -a, --artable           ar data
  --additionaldatatables  additional tables in tsv/csv format
  ```

The required inputs for rendering the report are a project name (the title of the report), a username (who generated the report), a sample table (table with metadata for the samples analyzed) and a yaml configuration file. For example:  
```
Rscript render_report.R 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```

Adding the -s option with a SNP matrix in tsv/csv format will plot the SNP matrix as a heatmap in the report.
```
Rscript render_report.R -s test_data/snp_distance_matrix.tsv 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```

Adding the -t option with a phylogenetic tree in newick format will plot a tree in the report
```
Rscript render_report.R -t test_data/core_genome.tree 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```

Adding the -c option with core genome statistics from the output of [Roary](https://sanger-pathogens.github.io/Roary/) will add a table of those statistics to the report
```
Rscript render_report.R -c test_data/core_genome_statistics.txt 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```

Adding the -a option with a table of AR genes in csv/tsv format will add a table of those genes to the report
```
Rscript render_report.R -a test_data/ar_predictions.tsv 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```  
Adding the --additionaldatatables option with other tables in csv/tsv format will add those tables to the report  
```
Rscript render_report.R --additionaldatatables test_data/mlst_formatted.tsv 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```  
Multiple tables can be added using the --additionaldatatables option, but they must be listed as so:  
```
Rscript render_report.R --additionaldatatables 'test_data/mlst_formatted.tsv test_data/S01.mash.tsv' 'AR Report' 'Abigail Shockey' test_data/samples.csv ar_report_config.yaml
```  
### Dependencies

A Docker container of the Rmarkdown files' dependencies can be pulled from [quay.io/wslh-bioinformatics/ar-report:1.0.0](https://quay.io/repository/wslh-bioinformatics/ar-report). The R Markdown scripts have many dependencies, so we highly recommend rendering the report using the Docker container. 

If you choose to manually render the report in RStudio, you will need to install the following R libraries from the [CRAN repository](https://cran.r-project.org/):  

* rmarkdown  
* argparser  
* yaml  
* knitr  
* rmarkdown  
* tidyverse  
* ggplot2  
* plotly  
* heatmaply  
* reticulate  
* kableExtra  
* pander  
* flextable  
* huxtable  
* officer  
* officedown  
* phytools  
* mnormt  
* BiocManager  
* ggtree  
## Authors
[Kelsey Florek](https://github.com/k-florek), WSLH Bioinformatics Scientist  
[Abigail Shockey](https://github.com/AbigailShockey), WSLH Bioinformatics Scientist
