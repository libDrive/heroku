#!/bin/bash

cd /usr/src/app

if [ -z "${LIBDRIVE_VERSION}" ]; then
    curl -L -s $(curl "https://api.github.com/repos/libDrive/libDrive/releases/latest" | grep -Po '"browser_download_url": "\K.*?(?=")') | tar xf - -C .
else
    curl -L -s $(curl "https://api.github.com/repos/libDrive/libDrive/releases/${LIBDRIVE_VERSION}" | grep -Po '"browser_download_url": "\K.*?(?=")') | tar xf - -C .
fi

pip3 install -r requirements.txt -q --no-cache-dir

gunicorn main:app
