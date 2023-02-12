#!/bin/bash
 # options explanation at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
set -x

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

git submodule init
git submodule update

gem install bundler:1.17.3
bundle _1.17.3_
rake website:parse_tournaments
rake website:parse_collections

cd website
bundle
middleman build
middleman deploy
