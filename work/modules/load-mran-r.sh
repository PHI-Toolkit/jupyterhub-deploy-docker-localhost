#!/bin/bash
cd /tmp
wget https://mran.microsoft.com/install/mro/3.4.1/microsoft-r-open-3.4.1.tar.gz
tar zxvf microsoft-r-open-3.4.1.tar.gz
cd microsoft-r-open
sudo ./install.sh -a
cd ..
sudo rm microsoft-r-open-3.4.1.tar.gz
sudo rm -fvR microsoft-r-open
cd /home/jovyan/work
sudo mkdir -p /usr/local/lib/R/site-library
sudo chmod a+w -R /usr/local/lib/R/site-library
sudo chmod a+w -R /usr/lib64/microsoft-r/3.4/lib64/R/library

sudo apt-get install -y libcurl4-openssl-dev zlib1g-dev libssl-dev libssh2-1-dev libxml2-dev libjepg62-turbo-dev \
    liblapack-dev libblas-dev
sudo R -e "install.packages(c('curl','httr','openssl'), dependencies=TRUE, repos='http://mran.microsoft.com')"
sudo R -e "install.packages(c('devtools'), dependencies=TRUE, repos='http://mran.microsoft.com')"
sudo R -e "devtools::install_github('IRkernel/IRkernel')"
#R -e "devtools::install_github(paste0('IRkernel/', c('repr', 'IRdisplay', 'IRkernel')))" && \
sudo R -e "IRkernel::installspec()"
