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
conda install --yes -c conda-forge geos osmnx gmaps geopy
conda install --yes -c ioam holoviews=1.8.0 geoviews
conda install obspy geopandas mplleaflet cartopy
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy

git clone https://github.com/jwass/geopandas_osm.git
cd geopandas_osm
python setup.py install
cd ..
rm -fvR geopandas_osm

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
conda install --yes -c conda-forge geos osmnx gmaps geopy
conda install --yes -c ioam holoviews=1.8.0 geoviews
conda install obspy geopandas mplleaflet cartopy
git clone https://github.com/jwass/geopandas_osm.git
cd geopandas_osm
python setup.py install
cd ..
rm -fvR geopandas_osm

conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
source deactivate
