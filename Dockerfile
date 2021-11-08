# base image
FROM ubuntu:xenial

# metadata
LABEL base.image="ubuntu:xenial"
LABEL dockerfile.version="1"
LABEL description="Docker image to render a report from the output of pipelines that examine prokaryote relatedness in outbreaks"
LABEL website="https://github.com/wslh-bio/ar_report_generator"
LABEL maintainer="Abigail Shockey"
LABEL maintainer.email="abigail.shockey@slh.wisc.edu"

# install ubuntu dependencies
RUN apt-get update && \
  apt-get -y install software-properties-common \
  apt-transport-https \
  ca-certificates \
  gnupg \
  curl \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2 \
  libxml2-dev \
  pandoc \
  pandoc-citeproc \
  wget \
  git \
  imagemagick \
  libmagick++-dev \
  texlive-latex-base \
  texlive-fonts-recommended \
  texlive-latex-recommended \
  texlive-latex-extra \
  texlive-xetex \
  fonts-roboto \
  build-essential \
  libpcre2-dev \
  pcre2-utils && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/jgm/pandoc/releases/download/2.15/pandoc-2.15-1-amd64.deb && \
  dpkg -i ./pandoc-2.15-1-amd64.deb

# add keys and ppa; update sources; build R dependencies
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9 && \
  add-apt-repository ppa:marutter/c2d4u3.5 && \
  echo "deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/" >> /etc/apt/sources.list && \
  cp /etc/apt/sources.list /etc/apt/sources.list~ && \
  sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
  apt-get update && apt-get -y upgrade && apt-get -y build-dep r-base

# Install R 4.1.1 from source
RUN wget https://cran.r-project.org/src/base/R-4/R-4.1.1.tar.gz && \
  tar -xvf R-4.1.1.tar.gz && \
  cd R-4.1.1 && \
  ./configure --prefix=/bin/R/4.1.1 --enable-R-shlib && \
  make && \
  make install

# Add R to path
ENV PATH "$PATH:/bin/R/4.1.1/bin"

# install R packages
RUN R -e "install.packages(c('devtools'), repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('argparser', version = '0.7.1', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('yaml', version = '2.2.1', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('knitr', version = '1.36', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('rmarkdown', version = '2.11', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('tidyverse', version = '1.3.1', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('ggplot2', version = '3.3.5', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('plotly', version = '4.10.0', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('heatmaply', version = '1.3.0', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('reticulate', version = '1.22', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('kableExtra', version = '1.3.4', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('pander', version = '0.6.4', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('flextable', version = '0.6.9', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('huxtable', version = '5.4.0', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('officer', version = '0.4.0', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('officedown', version = '0.2.2', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('phytools', version = '0.7-90', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('mnormt', version = '2.0.2', repos = 'http://cran.us.r-project.org')" && \
  R -e "devtools::install_version('BiocManager', version = '1.30.16', repos = 'http://cran.us.r-project.org')" && \
  R -e "BiocManager::install('ggtree')"

# Install Python 3.8 from source
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz && \
  tar -xvf Python-3.8.0.tgz && \
  cd Python-3.8.0 && \
  ./configure --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" --enable-optimizations && \
  make altinstall

# Install pip 3.8, Plotly and Kaleido
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python3.8 get-pip.py && \
  pip3.8 install -U plotly==5.3.1 kaleido==0.2.1

WORKDIR /data

# just in case for singularity compatibility
ENV LC_ALL=C
