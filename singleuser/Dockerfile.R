# Version: 20190203
FROM phitoolkit/notebook-base:latest
ARG JUPYTERHUB_VERSION
ARG JUPYTERLAB_VERSION
ARG NOTEBOOK_VERSION
ARG NB_USER_PASS
ARG GITHUB_ACCESS_TOKEN
ARG GITHUB_CLIENT_ID
ARG GITHUB_CLIENT_SECRET

RUN \
    conda install -c conda-forge --yes \
      # begin stack
      'r-base=3.5.1' \
      'r-irkernel=1.0*' \
      'r-plyr=1.8*' \
      'r-devtools=1.13*' \
      'r-tidyverse=1.2*' \
      'r-shiny=1.3*' \
      'r-rmarkdown' \
      'r-forecast=8.2*' \
      'r-rsqlite=2.1*' \
      'r-reshape2=1.4*' \
      'r-caret=6.0*' \
      'r-rcurl=1.95*' \
      'r-crayon=1.3*' \
      'r-randomforest=4.6*' \
      'r-htmltools=0.3*' \
      'r-sparklyr=1.0*' \
      'r-htmlwidgets=1.3*' \
      'r-hexbin=1.27*' && \
      # end stack
    conda build purge-all && \
    conda clean --all -y -f

RUN \
    conda install -c conda-forge --yes \
      # start of r-sf unit
      'r-sf' \
      'gdal' \
      'libgdal' \
      'r-rgdal' \
      'r-classint' \
      'r-dbi' \
      'r-magrittr' \
      'libcxx' \
      'r-rcpp' \
      'r-units' \
      '_r-mutex' \
      'proj4' \
      # end of r-sf unit
      'jupyter_contrib_core=0.3*' \
      'jupyter_contrib_nbextensions=0.5*' \
      'jupyter_nbextensions_configurator' \
      'widgetsnbextension=3.4*' \
      'nodejs' \
      'nbconvert' && \
    conda build purge-all && \
    conda clean --all -f -y

# insert RUN here if build fails
RUN \
    pip install --upgrade pip && \
    pip install  --no-cache-dir --upgrade "ipython[all]" && \
    pip install --no-cache-dir --upgrade \
      'twisted' \
      'hyper' \
      'h2' \
      'perspective-python' \
      'lineup_widget' \
      'ujson' \
      'websocket' \
      'future' \
      'apiclient' \
      'jupyter_disqus' \
      'jupyterlab_latex' \
      'jupyterlab_geojson==0.4.0' \
      'jupyterlab-widgets==0.6.15' \
      'tornado' && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    jupyter nbextensions_configurator enable --user

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/

USER $NB_USER
COPY work .

RUN sudo chown 1000:100 /home/jovyan/.conda/environments.txt && \
    sudo mkdir -p /opt/conda/pkgs/cache/ && \
    sudo chown -R 1000:100 /opt/conda/pkgs/cache/ && \
    sudo chmod a+x modules/*.sh && \
    sudo mkdir -p /srv/modules && \
    sudo mv modules/* /srv/modules/. && \
    sudo chmod a+w -R /home/jovyan/work/shared && \
    sudo chmod a+w -R /home/jovyan/work/notebooks && \
    sudo chmod a+w /home/jovyan/work/notebooks/*.ipynb && \
    sudo chown -R jovyan:users /home/jovyan && \
    sudo chown -R jovyan:users /home/jovyan/work/shared && \
    sudo chown -R jovyan:users /home/jovyan/work/notebooks && \
    mkdir -p /home/jovyan/.cache && \
    chmod -R a+w /home/jovyan/.cache && \
    chown -R jovyan:users /home/jovyan/.cache && \
    conda build purge-all && \
    conda clean --all -y -f

WORKDIR /home/jovyan/work

# Custom logo, create backup CSS file to enable restore if jupyter-themes overwrites it and the GEEKS logo
ARG LOGO_IMAGE
RUN echo $LOGO_IMAGE && \
    mkdir -p /home/jovyan/.jupyter/custom && \
    chown -R $NB_USER /home/jovyan/.jupyter
ADD css/custom.css /home/jovyan/.jupyter/custom/custom.css
ADD css/$LOGO_IMAGE /home/jovyan/.jupyter/custom/non-default.png
# Address iopub data error message with custom config
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN \
    sudo chown jovyan:users /home/jovyan/.jupyter/custom/non-default.png && \
    sudo chown -R jovyan:users /opt/ && \
    cp /home/jovyan/.jupyter/custom/custom.css /home/jovyan/.jupyter/custom/custom.css.backup && \
    jupyter nbextension enable --py --sys-prefix lineup_widget && \
    jupyter nbextension install --py widgetsnbextension --sys-prefix && \
    jupyter nbextension enable widgetsnbextension --py --sys-prefix && \
    conda build purge-all

#RUN \
#    conda config --add channels intel && \
#    conda install intelpython3_core && \
#    conda remove --quiet --yes --force qt pyqt && \
#    conda clean -tipsy

USER root

ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib

# restore password for sudo access
ENV PROJ_LIB=/usr/share/proj
RUN \
    rm -fvR modules && \
    conda clean --all -y -f && \
    rm -fvR /opt/conda/pkgs/* && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /opt/conda/pkgs/cache && \
    chmod -R a+w /opt/conda/pkgs/cache/ && \
    if [ "$NB_USER_PASS" != "" ]; then echo $NB_USER:$NB_USER_PASS | /usr/sbin/chpasswd;  \
      sed -i 's/ NOPASSWD://g' /etc/sudoers; fi
WORKDIR /home/jovyan/work
USER $NB_USER
