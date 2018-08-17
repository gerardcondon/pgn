#!/bin/bash
 # options explanation at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
set -x

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

git submodule init
git submodule update

bundle
rake website:parse_tournaments
rake website:parse_collections

cd website
bundle
middleman build
#middleman deploy