#!/bin/bash

# Hide Code in Cell
sudo /opt/conda/bin/pip install hide_code
sudo /opt/conda/bin/jupyter nbextension install --py hide_code
sudo /opt/conda/bin/jupyter nbextension enable --py hide_code
sudo /opt/conda/bin/jupyter serverextension enable --py hide_code

source activate python2
sudo /opt/conda/bin/pip install hide_code
sudo /opt/conda/bin/jupyter nbextension install --py hide_code
sudo /opt/conda/bin/jupyter nbextension enable --py hide_code
sudo /opt/conda/bin/jupyter serverextension enable --py hide_code
source deactivate
