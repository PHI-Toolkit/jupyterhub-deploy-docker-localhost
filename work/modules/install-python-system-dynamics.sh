pip install pysd geopandas
conda install --yes -c auto parsimonious
conda install --yes -c conda-forge pymc3
conda install --yes -c anaconda networkx
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy

source activate python2
pip install pysd geopandas
conda install --yes -c auto parsimonious
conda install --yes -c conda-forge pymc3
conda install --yes -c anaconda networkx
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
source deactivate
