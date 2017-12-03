ARG DOCKER_NOTEBOOK_IMAGE
FROM $DOCKER_NOTEBOOK_IMAGE
ARG JUPYTERHUB_VERSION
RUN python3 -m pip install --no-cache jupyterhub==$JUPYTERHUB_VERSION

USER root

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /home/jovyan/work

RUN ln -sf /bin/bash /bin/sh && \
    ln -s /bin/tar /bin/gtar

# install jupyterlab, jupyter_client
# libav-tools for matplotlib anim
# install R libraries and pre-requisites
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    conda install --yes -c conda-forge jupyterlab jupyter_client && \
    jupyter serverextension enable --py jupyterlab --sys-prefix && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:opencpu/jq --yes && \
    add-apt-repository ppa:ubuntugis/ppa && \
    apt-get update && \
    apt-get install -y gdal-bin libav-tools libgeos-dev nano \
      libffi-dev g++ libssl-dev libfreetype6-dev \
      python-dev libxml2-dev libxslt1-dev antiword unrtf poppler-utils pstotext tesseract-ocr \
      flac ffmpeg lame libmad0 libsox-fmt-mp3 sox libjpeg-dev swig \
      aptitude libmariadb-client-lgpl-dev fonts-dejavu gfortran gcc \
      libcairo2 mesa-common-dev libglu1-mesa-dev libudunits2-dev libgdal-dev \
      libjq-dev libv8-3.14-dev libprotobuf-dev protobuf-compiler libproj-dev \
          libgeos++-dev zip unzip && \
    export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib && \
    aptitude install -y libmagick++-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod -R a+w /opt/conda/ && \
    chown -R root:users /opt/conda && \
    chmod g+s /opt/conda

USER $NB_USER

# R packages
# These need to go together in conda install: 'libspatialite', 'r-rsqlite', 'r-rgdal'
RUN conda install --quiet --yes \
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
    'r-randomforest=4.6*' && \
    conda install -c conda-forge -c brown-data-science -c r -c blaze --yes \
    'libspatialite' \
    'r-rsqlite' \
    'r-rgdal' \
    'r-sp' \
    'r-e1071=1.6_7' \
    'r-rpart=4.1.8' \
    'r-xml=3.98_1.5' \
    'r-quantmod=0.4_7' \
    'r-rvest=0.3.2' \
    'r-maps=3.1.1' \
    'r-htmlwidgets=0.8' \
    'r-visnetwork' \
    'r-igraph ' \
    'r-topicmodels' \
    'r-tm' && \
    conda clean -tipsy
RUN R -e "install.packages(c('text2vec','raster','rgeos'), dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    R -e "install.packages(c('leaflet','geojsonio','protolite'),repos='http://cran.rstudio.com')"

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
# Unversion hdf5' and 'h5py' for 'rgdal' compatibility
USER $NB_USER
RUN conda install --quiet -c conda-forge --yes \
    'nomkl' \
    'ipywidgets=7.0*' \
    'pandas=0.19*' \
    'numexpr=2.6*' \
    'matplotlib=2.0*' \
    'scipy=0.19*' \
    'seaborn=0.7*' \
    'scikit-learn=0.18*' \
    'scikit-image=0.12*' \
    'sympy=1.0*' \
    'cython=0.25*' \
    'patsy=0.4*' \
    'statsmodels=0.8*' \
    'cloudpickle=0.2*' \
    'dill=0.2*' \
    'numba=0.31*' \
    'bokeh=0.12.9' \
    'sqlalchemy=1.1*' \
    'hdf5' \
    'h5py' \
    'beautifulsoup4=4.5.*' \
    'icu' \
    'missingno' \
    'blaze' \
    'pandas-datareader' \
    'textblob' \
    'jupyter_contrib_nbextensions' \
    'xlrd'  && \
    conda install -c conda-forge -c ioam -c bioconda -c anaconda --yes \
    'rpy2' \
    'pyproj' \
    'pillow' \
    'fiona' \
    'rasterio' \
    'geojson' \
    'pyshp' \
    'shapely' \
    'obspy' \
    'geopandas' \
    'mplleaflet' \
    'plotly' \
    'folium' \
    'holoviews' \
    'geoviews' \
    'xarray' \
    'iris' \
    'bkcharts' \
    'basemap' \
    'basemap-data-hires' \
    'networkx' \
    'osmnx' \
    'cartopy' \
    'proj4' \
    'datashader' && \
    pip install --upgrade pip && \
    pip install cufflinks sklearn-pandas epipy googletrans hyper fuzzywuzzy python-Levenshtein && \
    jupyter nbextension install https://rawgit.com/jfbercher/jupyter_nbTranslate/master/nbTranslate.zip --user && \
    jupyter nbextension enable nbTranslate/main && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy

# Activate ipywidgets extension in the environment that runs the notebook server\
USER root
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

USER $NB_USER
RUN conda install conda-build && \
    conda clean -tipsy

COPY work .

RUN sudo chmod a+x modules/*.sh && \
    sudo mkdir -p /srv/modules && \
    sudo mv modules/* /srv/modules/. && \
    sudo chmod a+w -R /home/jovyan/work/shared && \
    sudo chmod a+w -R /home/jovyan/work/geoserver && \
    sudo chmod a+w -R /home/jovyan/work/notebooks && \
    sudo chmod a+w /home/jovyan/work/notebooks/*.ipynb && \
    sudo chown -R jovyan:users /home/jovyan && \
    sudo chown -R jovyan:users /home/jovyan/work/shared && \
    sudo chown -R jovyan:users /home/jovyan/work/geoserver && \
    sudo chown -R jovyan:users /home/jovyan/work/notebooks && \
    mkdir -p /home/jovyan/.cache && \
    chmod -R a+w /home/jovyan/.cache && \
    chown -R jovyan:users /home/jovyan/.cache

WORKDIR /home/jovyan/work

# Uncomment the following lines to load the Julia kernel and Python, R and Julia modules
# You can also load the following inside the runnng Notebook single-user container through terminal
#RUN /srv/modules/install-scijava-kernel.sh
#RUN /srv/modules/restore-tutorial.sh
#RUN /srv/modules/install-python2-kernel.sh
#RUN /srv/modules/install-julia-kernel.sh
#RUN /srv/modules/load-julia-modules.sh

# Custom logo, create backup CSS file to enable restore if jupyter-themes overwrites it and the GEEKS logo
ARG LOGO_IMAGE
RUN echo $LOGO_IMAGE && \
    mkdir -p /home/jovyan/.jupyter/custom
ADD css/custom.css /home/jovyan/.jupyter/custom/custom.css
ADD css/$LOGO_IMAGE /home/jovyan/.jupyter/custom/non-default.png
RUN sudo chown jovyan:users /home/jovyan/.jupyter/custom/non-default.png && \
    cp /home/jovyan/.jupyter/custom/custom.css /home/jovyan/.jupyter/custom/custom.css.backup

# Address iopub data error message
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

USER root

RUN conda update jupyterlab && \
    conda clean -tipsy && \
    aptitude install zip unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER $NB_USER
#RUN jupyter labextension install @jupyterlab/google-drive
