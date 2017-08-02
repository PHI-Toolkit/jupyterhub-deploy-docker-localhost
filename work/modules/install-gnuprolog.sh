#!/bin/bash
# https://github.com/matsubara0507/iprolog/blob/master/Dockerfile
sudo apt-get update && apt-get install -y --no-install-recommends \
    gprolog \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

cd tmp
git clone https://github.com/matsubara0507/iprolog.git

cd iprolog/kernels
jupyter kernelspec install prolog
