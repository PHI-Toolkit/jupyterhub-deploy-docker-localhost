#!/bin/bash
# this installs protobuf for facets-overview using conda
# see source install instructions at https://github.com/google/protobuf/tree/master/python
sudo /opt/conda/bin/conda install -c anaconda --yes protobuf
cd /srv/modules/
sudo rm -fvR facets
sudo rm -fvR /opt/conda/share/jupyter/nbextensions/facets-dist
sudo git clone https://github.com/PAIR-code/facets
cd facets
sudo /opt/conda/bin/jupyter nbextension install facets-dist/
cp -R facets-dist /home/jovyan/.local/share/jupyter/nbextensions/.

source activate python2
sudo /opt/conda/bin/conda install -c anaconda --yes protobuf
sudo rm -fvR /opt/conda/envs/python2/share/jupyter/nbextensions/facets-dist
cd /srv/modules/facets
sudo /opt/conda/bin/jupyter nbextension install facets-dist/
source deactivate
