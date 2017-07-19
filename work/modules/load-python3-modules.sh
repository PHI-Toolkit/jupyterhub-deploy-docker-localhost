#!/bin/bash
# Python libraries

pip3 install --upgrade pip
pip3 install lightning-python pymongo psycopg2 \
      missingno plotly folium toyplot TextBlob geopandas mplleaflet cartodb \
      bubbles python-arango findspark epipy scikit-surprise ipynb graphviz cachey \
      sklearn-pandas
pip3 install dask[complete] smopy gmplot

conda install --yes -c anaconda mysql-connector-python=2.0.4
conda install --yes -c conda-forge bokeh=0.12.4
conda install --yes -c conda-forge geos osmnx gmaps
conda install --yes -c ioam holoviews=1.8.0 geoviews=1.3.0
conda install --yes xarray

conda install --yes -c bokeh datashader=0.5.0
conda install --yes -c conda-forge iris pyshp pandas-datareader obspy basemap \
      basemap-data-hires elasticsearch
conda install --yes -c conda-forge jupyter_contrib_nbextensions jupyter_dashboards
conda install --yes -c blaze blaze
conda install --yes -c anaconda scrapy simplejson
conda install --yes -c conda-forge jupyter_cms
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
