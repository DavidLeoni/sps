#!/bin/sh
set -o errexit #abort if any command fails
set -v

#https://github.com/DavidLeoni/jupman.git
GIT_URL=$1
# es 'jupman' also used as name for pdfs and epubs
# NOTE: you don't need to actually have a project on readthedocs servers!
RTD_PRJ_NAME=$2
#requirements.txt
REQUIREMENTS=$3
RTD_PRJ_PATH=/home/docs/checkouts/readthedocs.org/user_builds/$RTD_PRJ_NAME

echo "using        GIT_URL=$GIT_URL"
echo "using   RTD_PRJ_NAME=$RTD_PRJ_NAME"
echo "using   REQUIREMENTS=$REQUIREMENTS"
echo "using   RTD_PRJ_PATH=$RTD_PRJ_PATH"


# Reproduce build of ReadTheDocs --- START

# MANUALLY ADDED !
mkdir -p $RTD_PRJ_PATH/checkouts/latest/
# MANUALLY ADDED !
mkdir -p $RTD_PRJ_PATH/artifacts/latest/sphinx_pdf
# MANUALLY ADDED !
mkdir -p $RTD_PRJ_PATH/artifacts/latest/sphinx_epub
# MANUALLY ADDED !
cd $RTD_PRJ_PATH/checkouts/latest


git clone --no-single-branch --depth 50 $GIT_URL . 

git checkout --force origin/master 

git clean -d -f -f

# MANUALLY ADDED !
if [ -d "/github/workspace" ]; then  
  echo "Found Github Actions environment, redirecting _build to /github/workspace/"  
  ln -s /github/workspace/  $RTD_PRJ_PATH/checkouts/latest/_build
fi

python3.7 -mvirtualenv  $RTD_PRJ_PATH/envs/latest 

$RTD_PRJ_PATH/envs/latest/bin/python -m pip install --upgrade --no-cache-dir pip


# modded to add quotes for < so shell doesn't complain
$RTD_PRJ_PATH/envs/latest/bin/python -m pip install --upgrade --no-cache-dir Pygments==2.3.1 setuptools==41.0.1 docutils==0.14 mock==1.0.1 pillow==5.4.1 "alabaster>=0.7,<0.8,!=0.7.5" commonmark==0.8.1 recommonmark==0.5.0 "sphinx<2" "sphinx-rtd-theme<0.5" "readthedocs-sphinx-ext<1.1"


$RTD_PRJ_PATH/envs/latest/bin/python -m pip install --exists-action=w --no-cache-dir -r $REQUIREMENTS

cat conf.py

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/latest/bin/sphinx-build -T -E -b readthedocs -d _build/doctrees-readthedocs -D language=en . _build/html 

#MANUALLY ADDED FOR GITHUB PAGES
touch _build/html/.nojekyll

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/latest/bin/sphinx-build -T -b readthedocssinglehtmllocalmedia -d _build/doctrees-readthedocssinglehtmllocalmedia -D language=en . _build/localmedia

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/latest/bin/sphinx-build -b latex -D language=en -d _build/doctrees . _build/latex

#NOTE: MANUALLY ADDED !
cd ./_build/latex/

cat latexmkrc

latexmk -r latexmkrc -pdf -f -dvi- -ps- -jobname=$RTD_PRJ_NAME -interaction=nonstopmode 

mv -f $RTD_PRJ_PATH/checkouts/latest/./_build/latex/$RTD_PRJ_NAME.pdf $RTD_PRJ_PATH/artifacts/latest/sphinx_pdf/$RTD_PRJ_NAME.pdf

#NOTE: MANUALLY ADDED !
cd $RTD_PRJ_PATH/checkouts/latest

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/latest/bin/sphinx-build -T -b epub -d _build/doctrees-epub -D language=en . _build/epub

mv -f $RTD_PRJ_PATH/checkouts/latest/./_build/epub/$RTD_PRJ_NAME.epub $RTD_PRJ_PATH/artifacts/latest/sphinx_epub/$RTD_PRJ_NAME.epub 

# Reproduce build of ReadTheDocs  -- END

