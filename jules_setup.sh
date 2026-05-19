#!/bin/bash

# Jules Environment Setup Script
# These commands should be run (or configured in Jules UI) to prepare the environment for this repository.

npm install -g sass dart-sass
curl -L https://github.com/gohugoio/hugo/releases/download/v0.128.0/hugo_extended_0.128.0_linux-amd64.tar.gz | tar -xz && sudo mv hugo /usr/local/bin/
git submodule update --init --recursive
