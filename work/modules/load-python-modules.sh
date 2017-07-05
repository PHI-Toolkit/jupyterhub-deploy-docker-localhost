#!/bin/bash
# Python libraries
pip3 install --upgrade pip
pip3 install lightning-python pymongo psycopg2 \
      missingno plotly folium toyplot TextBlob geopandas mplleaflet cartodb \
      bubbles python-arango findspark epipy scikit-surprise ipynb graphviz cachey
pip3 install dask[complete] smopy gmplot

conda install --yes -c anaconda mysql-connector-python=2.0.4
conda install --yes -c conda-forge bokeh=0.12.4
conda install --yes -c conda-forge -c ioam holoviews>=1.6.2 geos geoviews osmnx gmaps
conda install --yes xarray

conda install --yes -c conda-forge iris ipyleaflet pyshp pandas-datareader obspy basemap \
      basemap-data-hires elasticsearch
conda install --yes -c conda-forge jupyter_contrib_nbextensions jupyter_dashboards
conda install --yes -c blaze blaze
conda install --yes -c anaconda scrapy simplejson
conda install --yes -c anaconda biopython
conda install --yes -c bokeh datashader=0.5.0
conda install --yes -c https://conda.anaconda.org/biocore scikit-bio
jupyter nbextension enable --py --sys-prefix ipyleaflet
conda install --yes -c conda-forge jupyter_cms

source activate /opt/conda/envs/python2
pip install --upgrade pip
pip install lightning-python pymongo psycopg2 \
  missingno plotly folium toyplot TextBlob geopandas mplleaflet cartodb \
  bubbles python-arango findspark epipy scikit-surprise graphviz cachey
pip install dask[complete] smopy gmplot
source deactivate

source activate /opt/conda/envs/python2
conda install --yes -c anaconda mysql-connector-python=2.0.4
conda install --yes -c conda-forge bokeh=0.12.4
conda install --yes -c conda-forge -c ioam holoviews>=1.6.2 geos geoviews osmnx gmaps
conda install --yes xarray
source deactivate

source activate /opt/conda/envs/python2
conda install --yes -c conda-forge iris ipyleaflet pyshp pandas-datareader obspy basemap \
      basemap-data-hires elasticsearch
conda install --yes -c conda-forge jupyter_contrib_nbextensions jupyter_dashboards
conda install --yes -c blaze blaze
conda install --yes -c anaconda scrapy simplejson
conda install --yes -c anaconda biopython
conda install --yes -c bokeh datashader=0.5.0
jupyter nbextension enable --py --sys-prefix ipyleaflet
conda install --yes -c conda-forge jupyter_cms
source deactivate
