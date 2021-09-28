#!/bin/bash
# 2021-09-27

# download miniconda to copy into Docker.jupyterhub
if [[ ! -f ./miniconda.sh ]]; then
    echo "Downloading miniconda..."
    MINICONDA_FILE=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    while true;do
        wget -T 15 -c $MINICONDA_FILE -O ./miniconda.sh && break
    done
fi
# download kite installer to copy into Dockerfile.tail
if [[ ! -f ./kite-installer ]]; then
    echo "Downloading kite installer..."
    KITE_FILE=https://linux.kite.com/linux/current/kite-installer
    wget $KITE_FILE -O singleuser/kite/kite-installer
    chmod a+x singleuser/kite/kite-installer
fi
