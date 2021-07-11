# AR Report Generator

AR Report Generator is an R script used to render a report from the output of pipelines that examine prokaryote relatedness in outbreaks e.g. [Dryad](https://github.com/wslh-bio/dryad). AR Report Generator uses Rmarkdown and Plotly to generator and interactive html document.

## Usage

Running the report generator using 'Rscript render_report.R' provides a menu of options:

```usage: render_report.R [--] [--help] [--opts OPTS] [--date DATE]
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
  -x, --opts              RDS file containing argument values
  -d, --date              set date of report, default: current date
                          [default: 2021-07-11]
  -s, --snpmatrix         csv/tsv of snp data
  -t, --tree              tree data
  -c, --cgstats           prokka cg stats 'core_genome_statistics.txt'
  -a, --artable           ar data
  ```

The required inputs for rendering the report are a project name, a username, a sample table and a yaml configuration file.

## Authors
[Kelsey Florek](https://github.com/k-florek), WSLH Bioinformatics Scientist  
[Abigail Shockey](https://github.com/AbigailShockey), WSLH Bioinformatics Scientist
