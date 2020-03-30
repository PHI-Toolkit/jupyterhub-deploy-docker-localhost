#!/bin/bash
conda install -c conda-forge -y 'spacy-langdetect'
python spacy_coreweb.py
python spacy_wordvectors.py
python spacy_entwiki.py
