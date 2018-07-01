#!/usr/bin/env bash
# Any subsequent commands which fail will cause the shell script to exit immediately
set -e

cd ${TRAVIS_BUILD_DIR}/src/
Rscript ${TRAVIS_BUILD_DIR}/3-tinytex/install_texlive.R
Rscript -e 'tinytex::pdflatex("main.tex", bib_engine = "biber")'
