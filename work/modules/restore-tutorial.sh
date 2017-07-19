#!/bin/bash
sudo apt-get update
sudo apt-get install -y zip unzip
cp /srv/modules/Jupyter-Notebook-Tutorial.zip /home/jovyan/work/shared/.
cd /home/jovyan/work/shared
unzip Jupyter-Notebook-Tutorial.zip
rm Jupyter-Notebook-Tutorial.zip
ls -la Jupyter-Notebook-Tutorial
sudo chown -R jovyan:users Jupyter-Notebook-Tutorial
