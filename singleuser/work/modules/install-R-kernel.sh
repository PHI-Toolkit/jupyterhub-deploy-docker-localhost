#!/bin/bash
# R packages
# install R libraries and pre-requisites
# These need to go together in conda install: 'libspatialite', 'r-rsqlite', 'r-rgdal'
conda install --quiet --yes \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*'

conda install -c conda-forge --yes \
    'libspatialite' \
    'r-rsqlite' \
    'r-rgdal' \
    'r-sf'

conda install -c conda-forge -c brown-data-science -c r -c blaze -c bioconda -c quasiben --yes \
    'r-reticulate' \
    'r-sp' \
    'r-e1071' \
    'r-rpart' \
    'r-xml' \
    'r-quantmod' \
    'r-rvest' \
    'r-maps' \
    'r-htmlwidgets' \
    'r-visnetwork' \
    'r-igraph ' \
    'r-leaflet' \
    'r-tm' \
    'r-protolite'

conda remove --quiet --yes --force qt pyqt
conda clean -tipsy

# devtools install 'viridis' and 'cividis' to avoid errors
R -e "install.packages(c('text2vec','crayon'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

R -e "devtools::install_github('sjmgarnier/viridis')"
R -e "devtools::install_github('marcosci/cividis')"
R -e "install.packages(c('raster','rgeos'), dependencies=TRUE, repos='http://cran.rstudio.com/')"
R -e "install.packages(c('geojsonio'),repos='http://cran.rstudio.com')"
