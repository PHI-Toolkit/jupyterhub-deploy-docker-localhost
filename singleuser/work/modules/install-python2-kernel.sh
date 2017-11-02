#!/bin/bash
# Install Python 2 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images

conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7
source deactivate
source activate python2 
    conda install --yes -c conda-forge \
    'nomkl' \
    'ipython=5.3*' \
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
    'bokeh=0.12*' \
    'hdf5=1.8.17' \
    'h5py=2.6*' \
    'sqlalchemy=1.1*' \
    'pyzmq' \
    'beautifulsoup4=4.5.*' \
    'icu' \
    'missingno' \
    'blaze' \
    'pandas-datareader' \
    'textblob' \
    'jupyter_contrib_nbextensions' \
    'xlrd'

conda install -c conda-forge -c ioam -c bioconda -c anaconda --yes \
    'gdal' \
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
    'cartopy'

pip install --upgrade pip
pip install cufflinks sklearn-pandas epipy googletrans hyper fuzzywuzzy
jupyter nbextension install https://rawgit.com/jfbercher/jupyter_nbTranslate/master/nbTranslate.zip --user
jupyter nbextension enable nbTranslate/main
conda remove -n python2 --quiet --yes --force qt pyqt
conda clean -tipsy 
source deactivate


# Add shortcuts to distinguish pip for python2 and python3 envs
# Import matplotlib the first time to build the font cache.
# fix-permissions $CONDA_DIR

# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime and to allow the notebook server running out of the root
# environment to find it. Also, activate the python2 environment upon kernel
# launch.

export XDG_CACHE_HOME /home/$NB_USER/.cache/
ln -s $CONDA_DIR/envs/python2/bin/pip $CONDA_DIR/bin/pip2 
ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3 
MPLBACKEND=Agg $CONDA_DIR/envs/python2/bin/python -c "import matplotlib.pyplot" 
MPLBACKEND=Agg $CONDA_DIR/bin/python -c "import matplotlib.pyplot"
pip install kernda --no-cache 
$CONDA_DIR/envs/python2/bin/python -m ipykernel install
kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json
pip uninstall kernda -y
