#!/bin/bash
# Python libraries
export CONDA2_BIN=/opt/conda/envs/python2/bin
export PIP2_BIN=/opt/conda/envs/python2/bin
export JUPYTER2_BIN=/opt/conda/envs/python2/bin

source activate /opt/conda/envs/python2

sudo $PIP2_BIN/pip install --upgrade pip
sudo $PIP2_BIN/pip install lightning-python pymongo psycopg2 \
  missingno plotly folium toyplot TextBlob geopandas mplleaflet cartodb \
  bubbles python-arango findspark epipy scikit-surprise graphviz cachey
sudo $PIP2_BIN/pip install dask[complete] smopy gmplot

sudo $CONDA2_BIN/conda install --yes -c anaconda mysql-connector-python=2.0.4
sudo $CONDA2_BIN/conda install --yes -c conda-forge bokeh=0.12.4
sudo $CONDA2_BIN/conda install --yes -c conda-forge geos osmnx gmaps
sudo $CONDA2_BIN/conda install --yes -c ioam holoviews=1.8.0 geoviews=1.3.0
sudo $CONDA2_BIN/conda install --yes xarray

sudo $CONDA2_BIN/conda install --yes -c bokeh datashader=0.5.0
sudo $CONDA2_BIN/conda install --yes -c conda-forge iris pyshp pandas-datareader obspy basemap \
      basemap-data-hires elasticsearch
sudo $CONDA2_BIN/conda install --yes -c conda-forge ipyleaflet
sudo $CONDA2_BIN/conda install --yes -c conda-forge jupyter_contrib_nbextensions jupyter_dashboards
sudo $CONDA2_BIN/conda install --yes -c blaze blaze
sudo $CONDA2_BIN/conda install --yes -c anaconda scrapy simplejson
sudo $JUPYTER2_BIN/jupyter nbextension enable --py --sys-prefix ipyleaflet
sudo $CONDA2_BIN/conda install --yes -c conda-forge jupyter_cms

sudo $CONDA2_BIN/conda remove --quiet --yes --force qt pyqt
sudo $CONDA2_BIN/conda clean -tipsy

source deactivate
