#!/bin/bash

# 2021-09-27

python spacy_coreweb.py
python spacy_wordvectors.py
python spacy_entwiki.py
pip install scispacy spacy-langdetect
pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.2.4/en_core_sci_lg-0.2.4.tar.gz
pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.2.4/en_ner_bionlp13cg_md-0.2.4.tar.gz
