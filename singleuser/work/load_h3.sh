#!/bin/bash
conda install -c conda-forge -y h3 h3-py
conda build purge-all
conda clean --all -f -y
conda remove --quiet --yes --force qt pyqt
