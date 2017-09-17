#!/bin/bash
conda create --name java_env scijava-jupyter-kernel
conda remove --quiet --yes --force qt pyqt
conda clean -tipsy
