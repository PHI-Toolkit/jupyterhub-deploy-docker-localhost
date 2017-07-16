#!/usr/bin/env bash
export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
sudo apt-get update
sudo apt-get install -y aptitude
sudo apt-get install -y libmariadb-client-lgpl-dev
sudo aptitude install -y libmagick++-dev
sudo apt-get install -y libcairo2- mesa-common-dev
sudo apt-get install -y libglu1-mesa-dev
sudo apt-get install -y libudunits2-dev libgdal-dev
sudo apt-get clean
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*

# conda install
conda install --yes -c r r-xml
conda install --yes gdal
conda install --yes -c bioconda r-plotly=4.5.6
conda install --yes -c r r-randomforest=4.6_12 r-e1071=1.6_7 r-rpart=4.1.8 r-xml=3.98_1.5 r-quantmod=0.4_7 \
  r-rvest=0.3.2 r-reshape2=1.4.2 r-tm=0.6_2 r-maps=3.1.1 r-htmlwidgets=0.8
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy

# install.packages()
R -e "install.packages(c('text2vec', 'topicmodels', 'quanteda'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
