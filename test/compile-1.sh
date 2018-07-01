#!/usr/bin/env bash

# Copied from 1-tectonic/.travis.yml without comments
export PATH="$HOME/miniconda/bin:$PATH"
if ! command -v conda > /dev/null; then
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
  bash miniconda.sh -b -p $HOME/miniconda -u;
  conda config --add channels conda-forge;
  conda config --set always_yes yes;
  conda update --all;
  conda install tectonic;
fi
conda info -a

cd ${TRAVIS_BUILD_DIR}/src/
tectonic ./main.tex --print