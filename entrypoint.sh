#!/bin/sh
set -o errexit #abort if any command fails
set -x

# NOTE: you don't need to actually have a project on readthedocs servers!
RTD_PRJ_NAME=$1  # 'jupman', also used as name for pdfs and epubs
GIT_URL=$2       # https://github.com/DavidLeoni/jupman.git
GIT_TAG=$3       # tag or branch, i.e.  master
VERSION=$4       # latest
REQUIREMENTS=$5  # requirements.txt
LANGUAGE=$6      # en

RTD_PRJ_PATH=/home/docs/checkouts/readthedocs.org/user_builds/$RTD_PRJ_NAME

echo "using   GIT_URL=$GIT_URL"
echo "using   VERSION=$VERSION"
echo "using   GIT_TAG=$GIT_TAG"
echo "using   RTD_PRJ_NAME=$RTD_PRJ_NAME"
echo "using   REQUIREMENTS=$REQUIREMENTS"
echo "using   LANGUAGE=$LANGUAGE"
echo "using   RTD_PRJ_PATH=$RTD_PRJ_PATH"

# Reproduce build of ReadTheDocs --- START

# MANUALLY ADDED !
mkdir -p $RTD_PRJ_PATH/checkouts/$VERSION/
# MANUALLY ADDED !
mkdir -p $RTD_PRJ_PATH/artifacts/$VERSION/sphinx_pdf
# MANUALLY ADDED !
mkdir -p $RTD_PRJ_PATH/artifacts/$VERSION/sphinx_epub

# MANUALLY ADDED !
cd $RTD_PRJ_PATH/checkouts/$VERSION


git clone --no-single-branch --depth 50 $GIT_URL . 

git checkout --force origin/$GIT_TAG 

git clean -d -f -f

python3.7 -mvirtualenv  $RTD_PRJ_PATH/envs/$VERSION 

$RTD_PRJ_PATH/envs/$VERSION/bin/python -m pip install --upgrade --no-cache-dir pip


# modded to add quotes for < so shell doesn't complain
$RTD_PRJ_PATH/envs/$VERSION/bin/python -m pip install --upgrade --no-cache-dir Pygments==2.3.1 setuptools==41.0.1 docutils==0.14 mock==1.0.1 pillow==5.4.1 "alabaster>=0.7,<0.8,!=0.7.5" commonmark==0.8.1 recommonmark==0.5.0 "sphinx<2" "sphinx-rtd-theme<0.5" "readthedocs-sphinx-ext<1.1"


$RTD_PRJ_PATH/envs/$VERSION/bin/python -m pip install --exists-action=w --no-cache-dir -r $REQUIREMENTS

cat conf.py

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/$VERSION/bin/sphinx-build -T -E -b readthedocs -d _build/doctrees-readthedocs -D language=$LANGUAGE . _build/html 

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/$VERSION/bin/sphinx-build -T -b readthedocssinglehtmllocalmedia -d _build/doctrees-readthedocssinglehtmllocalmedia -D language=$LANGUAGE . _build/localmedia

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/$VERSION/bin/sphinx-build -b latex -D language=$LANGUAGE -d _build/doctrees . _build/latex

#NOTE: MANUALLY ADDED !
cd ./_build/latex/

cat latexmkrc

latexmk -r latexmkrc -pdf -f -dvi- -ps- -jobname=$RTD_PRJ_NAME -interaction=nonstopmode 

#NOTE: using cp instead of mv
cp -f $RTD_PRJ_PATH/checkouts/$VERSION/./_build/latex/$RTD_PRJ_NAME.pdf $RTD_PRJ_PATH/artifacts/$VERSION/sphinx_pdf/$RTD_PRJ_NAME.pdf

#NOTE: MANUALLY ADDED !
cd $RTD_PRJ_PATH/checkouts/$VERSION

#NOTE: in original log line is prepended by 'python '
$RTD_PRJ_PATH/envs/$VERSION/bin/sphinx-build -T -b epub -d _build/doctrees-epub -D language=$LANGUAGE . _build/epub

#NOTE: using cp instead of mv
cp -f $RTD_PRJ_PATH/checkouts/$VERSION/./_build/epub/$RTD_PRJ_NAME.epub $RTD_PRJ_PATH/artifacts/$VERSION/sphinx_epub/$RTD_PRJ_NAME.epub 

# Reproduce build of ReadTheDocs  -- END

# MANUALLY ADDED !
zip _build/$RTD_PRJ_NAME-html-$LANGUAGE-$VERSION.zip _build/html

# MANUALLY ADDED !
if [ -d "/github/workspace" ]; then  
  echo "Extra: Found Github Actions environment, moving _build content to /github/workspace/"    
  mv _build/* /github/workspace
  
fi
