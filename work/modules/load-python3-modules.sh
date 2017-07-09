#!/bin/bash
# Python libraries
export CONDA3_BIN=/opt/conda/bin
export PIP3_BIN=/opt/conda/bin
export JUPYTER3_BIN=/opt/conda/bin

sudo $PIP3_BIN/pip3 install --upgrade pip
sudo $PIP3_BIN/pip3 install lightning-python pymongo psycopg2 \
      missingno plotly folium toyplot TextBlob geopandas mplleaflet cartodb \
      bubbles python-arango findspark epipy scikit-surprise ipynb graphviz cachey
sudo $PIP3_BIN/pip3 install dask[complete] smopy gmplot

sudo $CONDA3_BIN/conda install --yes -c anaconda mysql-connector-python=2.0.4
sudo $CONDA3_BIN/conda install --yes -c conda-forge bokeh=0.12.4
sudo $CONDA3_BIN/conda install --yes -c conda-forge geos osmnx gmaps
sudo $CONDA3_BIN/conda install --yes -c ioam holoviews=1.8.0 geoviews=1.3.0
sudo $CONDA3_BIN/conda install --yes xarray

sudo $CONDA3_BIN/conda install --yes -c bokeh datashader=0.5.0
sudo $CONDA3_BIN/conda install --yes -c conda-forge iris pyshp pandas-datareader obspy basemap \
      basemap-data-hires elasticsearch
sudo $CONDA3_BIN/conda install --yes -c conda-forge ipyleaflet
sudo $CONDA3_BIN/conda install --yes -c conda-forge jupyter_contrib_nbextensions jupyter_dashboards
sudo $CONDA3_BIN/conda install --yes -c blaze blaze
sudo $CONDA3_BIN/conda install --yes -c anaconda scrapy simplejson
#sudo $CONDA3_BIN/conda install --yes -c anaconda biopython
sudo $CONDA3_BIN/conda install --yes -c https://conda.anaconda.org/biocore scikit-bio
sudo $JUPYTER3_BIN/jupyter nbextension enable --py --sys-prefix ipyleaflet
sudo $CONDA3_BIN/conda install --yes -c conda-forge jupyter_cms
sudo $CONDA3_BIN/conda remove --quiet --yes --force qt pyqt
sudo $CONDA3_BIN/conda clean -tipsy
