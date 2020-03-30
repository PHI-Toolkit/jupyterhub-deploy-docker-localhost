#!/bin/bash
cd ../notebooks
if [[ ! -d 2018-GEEKS-Digital-Case-Study-Intro ]]; then
  git clone https://github.com/PHI-Case-Studies/2018-GEEKS-Digital-Case-Study-Intro.git
fi
if [[ ! -d 1854-Cholera-Outbreak-London-Basic ]]; then
  git clone https://github.com/PHI-Case-Studies/1854-Cholera-Outbreak-London-Basic.git
fi
if [[ ! -d 1854-Cholera-Outbreak-London-Advanced-1 ]]; then
  git clone https://github.com/PHI-Case-Studies/1854-Cholera-Outbreak-London-Advanced-1.git
fi
if [[ ! -d 1854-Cholera-Outbreak-London-Advanced-2 ]]; then
  git clone https://github.com/PHI-Case-Studies/1854-Cholera-Outbreak-London-Advanced-2.git
fi
if [[ ! -d 2019-HIV-Prevalence-Botswana ]]; then
  git clone https://github.com/PHI-Case-Studies/2019-HIV-Prevalence-Botswana.git
fi
