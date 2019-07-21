#!/bin/bash
DIR=$(dirname $(cd "$(dirname "$0")"; pwd))

cd $DIR

mkdir -p output
ruby -v
gem --version
gem install bundler:2.0.1
bundle install
bundle exec rake report:init
bundle exec rake report:publish

if [ "$1" == "CI" ];then
  ebook-convert output/doc.epub output/doc.mobi
  rm .gitignore
  mv output/doc.html index.html
fi
