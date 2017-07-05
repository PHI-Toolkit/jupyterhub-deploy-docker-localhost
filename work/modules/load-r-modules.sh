#!/usr/bin/env bash
R -e "install.packages(c('dplyr', 'tidyr', 'stringr', 'lubridate'), repos='http://cran.rstudio.com/')"
R -e "install.packages(c('jsonlite', 'XML', 'quantmod', 'rvest', 'reshape2'), repos='http://cran.rstudio.com/')"
R -e "install.packages(c('ggplot2', 'ggvis', 'rgl', 'htmlwidgets'), repos='http://cran.rstudio.com/')"
R -e "install.packages(c('knitr', 'plotly', 'RColorBrewer'), repos='http://cran.rstudio.com/')"
R -e "install.packages(c('randomForest', 'e1071', 'rpart'), repos='http://cran.rstudio.com/')"
R -e "install.packages(c('text2vec', 'tm', 'topicmodels', 'quanteda'), repos='http://cran.rstudio.com/')"
