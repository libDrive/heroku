#!/bin/bash

cd /usr/src/app/.bin

mkdir ./dev
cd ./dev
mkdir ./tmp
cd ./tmp
git clone "https://github.com/libDrive/server.git" --depth 1 server
git clone "https://github.com/libDrive/web.git" --depth 1 web
mkdir ./libDrive.Server
mkdir ./libDrive.Server/build
mkdir ./libDrive.Server/src
mkdir ./libDrive.Server/templates
cd ./web
yarn install
yarn run build
mv ./build/* ../libDrive.Server/build
cd ../server
mv main.py requirements.txt ../libDrive.Server
mv ./src/* ../libDrive.Server/src
mv ./templates/* ../libDrive.Server/templates
cd ..
cp ../../../README.md ../../../LICENSE ./libDrive.Server
cd libDrive.Server
mv ./* ../..
cd ../../..
