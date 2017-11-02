#!/bin/bash

# cmake needed for MbedTLS
sudo apt-get update
sudo apt-get install -y cmake

# install Julia
conda install --yes -c bioconda julia=0.5.2

# install IJulia
julia -e 'Pkg.init()'
julia -e 'Pkg.add("IJulia")'
julia -e 'Pkg.build("IJulia")'
sudo cp -R /root/.julia /home/jovyan/.julia
sudo chown -R jovyan:users /home/jovyan/.julia
sudo cp -R /root/.local/share/jupyter/kernels/julia-0.5/ /opt/conda/share/jupyter/kernels/

# clean up
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
sudo apt-get clean
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*
