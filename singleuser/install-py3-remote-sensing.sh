#!/bin/bash
mamba install -y -c conda-forge -n py3-remote-sensing \
    'proj-data'

# install libpostal
mkdir -p /home/jovyan/work/.data/libpostal
git clone https://github.com/openvenues/libpostal
cd libpostal
chmod a+x bootstrap.sh
./bootstrap.sh
./configure --datadir=/home/jovyan/work/.data/libpostal
make
sudo make install
sudo ldconfig

source activate py3-remote-sensing
$(which python) -m pip install postal
conda deactivate
