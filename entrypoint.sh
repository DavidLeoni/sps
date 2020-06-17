#!/bin/sh
set -o errexit #abort if any command fails


echo "creating some trial dir"
mkdir /github/home/peppo
touch /github/home/peppo/ciao.txt



cd /github/workspace
git clone https://github.com/DavidLeoni/jupman.git
cd jupman

pwd
ls -alhR  --color=yes
echo "showing /github"
ls -alhR  --color=yes /github

pip --version
pip install -U --user pip
echo 'Installing dependencies'
pip install --user  -r requirements-build.txt

echo 'Building site'
./build.py -q

touch _build/html/.nojekyll