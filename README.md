# AR Report Generator

AR Report Generator is an R script used to render a report from the output of pipelines that identify antibiotic resistance (AR) genes and/or examine prokaryote relatedness in outbreaks (e.g. [Spriggan](https://github.com/wslh-bio/dryad) and [Dryad](https://github.com/wslh-bio/dryad)).  

## Table of Contents:
[Usage](#usage)  
[Dependencies](#dependencies)  
[Output Format](#output-format)    
[Testing](#testing)  
[Report Logo](#report-logo)  
[Output Files](#output-files)  

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
Rscript render_report.R 'AR Report' 'Your Name' test_data/samples.csv ar_report_config.yaml
```

Adding the -s option with a SNP matrix in tsv/csv format will plot the SNP matrix as a heatmap in the report:
```
Rscript render_report.R -s test_data/snp_distance_matrix.tsv 'AR Report' 'Your Name' test_data/samples.csv ar_report_config.yaml
```

Adding the -t option with a phylogenetic tree in newick format will plot a tree in the report:
```
Rscript render_report.R -t test_data/core_genome.tree 'AR Report' 'Your Name' test_data/samples.csv ar_report_config.yaml
```

Adding the -c option with core genome statistics from the output of [Roary](https://sanger-pathogens.github.io/Roary/) will add a table of those statistics to the report:
```
Rscript render_report.R -c test_data/core_genome_statistics.txt 'AR Report' 'Your Name' test_data/samples.csv ar_report_config.yaml
```

Adding the -a option with a table of AR genes in csv/tsv format will add a table of those genes to the report:
```
Rscript render_report.R -a test_data/ar_predictions.tsv 'AR Report' 'Your Name' test_data/samples.csv ar_report_config.yaml
```  
Multiple additional tables can be added using the --additionaldatatables option, but they must be listed as so:  
```
Rscript render_report.R --additionaldatatables 'test_data/mlst_formatted.tsv test_data/S01.mash.tsv' 'AR Report' 'Your Name' test_data/samples.csv ar_report_config.yaml
```  

## Dependencies  
A Docker image of the generator's dependencies can be built using the [Dockerfile](https://github.com/wslh-bio/ar_report_generator/blob/main/Dockerfile) included in this repository, or pulled from [quay.io/wslh-bioinformatics/ar-report:1.0.0](https://quay.io/repository/wslh-bioinformatics/ar-report). The R Markdown scripts used to generate the report have many dependencies, so we highly recommend rendering the report using Docker. 

If you choose to render the report without Docker, you will need to install the following R packages:  
* [rmarkdown](https://cran.r-project.org/web/packages/rmarkdown/index.html)  
* [argparser](https://cran.r-project.org/web/packages/argparse/index.html)  
* [yaml](https://cran.r-project.org/web/packages/yaml/index.html)  
* [knitr](https://cran.r-project.org/web/packages/knitr/index.html)  
* [tidyverse](https://cran.r-project.org/web/packages/tidyverse/index.html)  
* [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)  
* [plotly](https://cran.r-project.org/web/packages/plotly/index.html)  
* [heatmaply](https://cran.r-project.org/web/packages/heatmaply/index.html)  
* [reticulate](https://cran.r-project.org/web/packages/reticulate/index.html)  
* [kableExtra](https://cran.r-project.org/web/packages/kableExtra/index.html)  
* [pander](https://cran.r-project.org/web/packages/pander/index.html)  
* [flextable](https://cran.r-project.org/web/packages/flextable/index.html)  
* [huxtable](https://cran.r-project.org/web/packages/huxtable/index.html)  
* [officer](https://cran.r-project.org/web/packages/officer/index.html)  
* [officedown](https://cran.r-project.org/web/packages/officedown/index.html)  
* [phytools](https://cran.r-project.org/web/packages/phytools/index.html)  
* [mnormt](https://cran.r-project.org/web/packages/mnormt/index.html)  
* [BiocManager](https://cran.r-project.org/web/packages/BiocManager/index.html)  
* [ggtree](https://bioconductor.org/packages/release/bioc/html/ggtree.html)

As well as the following Python packages:  
* [Plotly](https://plotly.com/python/)
* [Kaleido](https://github.com/plotly/Kaleido)

### A Note on Plotly, Kaleido and Reticulate:
When rendering the report in docx format, the report's figures are exported using the python packages Plotly and Kaleido, as well as the R package Reticulate. If you are rendering the report in docx format without the generator's Docker container, you must provide Reticulate the path to your installation of Python using the py.path parameter in the [yaml configuration file](https://github.com/wslh-bio/ar_report_generator/blob/main/ar_report_config.yaml)..

If you are not using the report generator's Docker container, we recommend installing Miniconda using R and the following commands:  
```
install.packages(c('reticulate'), repos='http://cran.us.r-project.org')
reticulate::install_miniconda(path='/miniconda',force=TRUE)
reticulate::conda_install('r-reticulate', 'python-kaleido')
reticulate::conda_install('r-reticulate', 'plotly', channel='plotly')
```

Or installing Python3.8 from source, Pip3.8, Plotly and Kaleido using the following commands:  

```
wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
tar -xvf Python-3.8.0.tgz
cd Python-3.8.0
./configure --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" --enable-optimizations
make altinstall

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.8 get-pip.py
pip3.8 install -U plotly==5.3.1 kaleido==0.2.1
```  

## Output format
The report can be rendered in two different formats: html and docx. The default output format is html, but this can be changed to docx using the outformat parameter in the [yaml configuration file](https://github.com/wslh-bio/ar_report_generator/blob/main/ar_report_config.yaml). Example reports in each format (generated using the data found in the [test_data folder](https://github.com/wslh-bio/ar_report_generator/tree/main/test_data)) can be found in the [examples folder](https://github.com/wslh-bio/ar_report_generator/tree/main/examples).

## Testing
The report generator can be tested by running the test.sh script:
```
./test.sh
```

## Report logo
A custom logo can be added to the report by specifying a path to the logo file in the [yaml configuration file](https://github.com/wslh-bio/ar_report_generator/blob/main/ar_report_config.yaml).
Note: A custom logo can only be added to the report when rendering in html format, but a custom logo can be
added to the report in docx format using a word processor after it has been rendered.

## Output files
```
├── *.ar-report.html
├── *.ar-report.docx
├── snp-plot.png
└── tree-plot.png
```
**\*.ar-report.html** - Report in html format (only when html option is used)  
**\*.ar-report.docx** - Report in docx format (only when docx option is used)  
**snp-plot.png** - SNP heatmap in png format (only when docx and SNP options are used)  
**tree-plot.png** - pPhylogenetic tree in png format (only when docx and tree options are used)  

## Authors  
[Kelsey Florek](https://github.com/k-florek), WSLH Bioinformatics Scientist  
[Abigail Shockey](https://github.com/AbigailShockey), WSLH Bioinformatics Scientist
