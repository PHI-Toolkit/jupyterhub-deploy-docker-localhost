#!/bin/bash
conda install -c ostrokach-forge graph-tool
conda install -c conda-forge osmnx
conda install -c anaconda networkx
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy

source activate python2
conda install -c ostrokach-forge graph-tool
conda install -c conda-forge osmnx
conda install -c anaconda networkx
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
source deactivate
