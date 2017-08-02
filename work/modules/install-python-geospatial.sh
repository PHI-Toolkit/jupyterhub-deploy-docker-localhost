#!/bin/bash
# based on http://mappingandco.com/blog/setting-up-a-geospatial-python-tool-box-with-conda/
conda install -c conda-forge --yes gdal
conda install --yes pyproj
conda install -c http://conda.anaconda.org/rbacher --yes spectral
conda install --yes pillow
conda install --yes fiona
conda install --yes rasterio
conda install --yes geojson
conda install -c http://conda.anaconda.org/rsignell --yes geopandas
conda install --yes pyshp
conda install -c https://conda.anaconda.org/ioos --yes descartes
conda install --yes matplotlib
conda install --yes shapely
conda install -c ioos mplleaflet
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy


source activate python2
conda install -c conda-forge --yes gdal
conda install --yes pyproj
conda install -c http://conda.anaconda.org/rbacher --yes spectral
conda install --yes pillow
conda install --yes fiona
conda install --yes rasterio
conda install --yes geojson
conda install -c http://conda.anaconda.org/rsignell --yes geopandas
conda install --yes pyshp
conda install -c https://conda.anaconda.org/ioos --yes descartes
conda install --yes matplotlib
conda install --yes shapely
conda install -c ioos mplleaflet
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
source deactivate
