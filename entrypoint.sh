#!/bin/sh
set -o errexit #abort if any command fails


# Reproduce build of ReadTheDocs  -- START

#NOTE: MANUALLY ADDED !
mkdir -p /home/docs/checkouts/readthedocs.org/user_builds/jupman/checkouts/latest

#NOTE: MANUALLY ADDED !
cd /home/docs/checkouts/readthedocs.org/user_builds/jupman/checkouts/latest

git clone --no-single-branch --depth 1 https://github.com/DavidLeoni/jupman . 

git checkout --force origin/master 

git clean -d -f -f

python3.7 -mvirtualenv  /home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest 

/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/python -m pip install --upgrade --no-cache-dir pip


# modded to add quotes for < so shell doesn't complain
/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/python -m pip install --upgrade --no-cache-dir Pygments==2.3.1 setuptools==41.0.1 docutils==0.14 mock==1.0.1 pillow==5.4.1 "alabaster>=0.7,<0.8,!=0.7.5" commonmark==0.8.1 recommonmark==0.5.0 "sphinx<2" "sphinx-rtd-theme<0.5" "readthedocs-sphinx-ext<1.1"


/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/python -m pip install --exists-action=w --no-cache-dir -r requirements-build.txt 

cat conf.py

#NOTE: in original log line is prepended by 'python '
/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/sphinx-build -T -E -b readthedocs -d _build/doctrees-readthedocs -D language=en . _build/html 

#MANUALLY ADDED FOR GITHUB PAGES
touch _build/html/.nojekyll

#NOTE: in original log line is prepended by 'python '
/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/sphinx-build -T -b readthedocssinglehtmllocalmedia -d _build/doctrees-readthedocssinglehtmllocalmedia -D language=en . _build/localmedia

#NOTE: in original log line is prepended by 'python '
/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/sphinx-build -b latex -D language=en -d _build/doctrees . _build/latex

#NOTE: MANUALLY ADDED !
cd ./_build/latex/

cat latexmkrc

latexmk -r latexmkrc -pdf -f -dvi- -ps- -jobname=jupman -interaction=nonstopmode 

mkdir -p /home/docs/checkouts/readthedocs.org/user_builds/jupman/artifacts/latest/sphinx_pdf

mv -f /home/docs/checkouts/readthedocs.org/user_builds/jupman/checkouts/latest/./_build/latex/jupman.pdf /home/docs/checkouts/readthedocs.org/user_builds/jupman/artifacts/latest/sphinx_pdf/jupman.pdf

#NOTE: MANUALLY ADDED !
cd /home/docs/checkouts/readthedocs.org/user_builds/jupman/checkouts/latest

#NOTE: in original log line is prepended by 'python '
/home/docs/checkouts/readthedocs.org/user_builds/jupman/envs/latest/bin/sphinx-build -T -b epub -d _build/doctrees-epub -D language=en . _build/epub

#NOTE: MANUALLY ADDED !
mkdir -p /home/docs/checkouts/readthedocs.org/user_builds/jupman/artifacts/latest/sphinx_epub

mv -f /home/docs/checkouts/readthedocs.org/user_builds/jupman/checkouts/latest/./_build/epub/jupman.epub /home/docs/checkouts/readthedocs.org/user_builds/jupman/artifacts/latest/sphinx_epub/jupman.epub 

# Reproduce build of ReadTheDocs  -- END

touch _build/html/.nojekyll