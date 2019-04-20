#!/bin/bash

mkdir -p output
bundle install
bundle exec rake report:init
bundle exec rake report:publish
ebook-convert output/doc.epub output/doc.mobi

if [ "$1" == "CI" ];then
  rm .gitignore
  mv output/doc.html index.html
fi
