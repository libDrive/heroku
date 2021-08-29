#!/bin/bash

cd /usr/src/app/.bin

if [ "${LIBDRIVE_VERSION}" != "dev" ]; then
    if [ ! -z "${LIBDRIVE_VERSION}" ]; then
        if [ "${LIBDRIVE_VERSION}" = "latest" ]; then
            VER="latest"
        else
            VER="tags/${LIBDRIVE_VERSION}"
        fi
    else
        VER="latest"
    fi

    if [ ! -z "${LIBDRIVE_REPOSITRY}" ]; then
        REPO=${LIBDRIVE_REPOSITRY}
    else
        REPO="libDrive/libDrive"
    fi

    curl -L -s $(curl -s "https://api.github.com/repos/${REPO}/releases/${VER}" | grep -Po '"browser_download_url": "\K.*?(?=")') | tar xf - -C .

    pip3 install -r requirements.txt -q --no-cache-dir
else
    cd ./dev
fi

pip3 install -r requirements.txt -q --no-cache-dir
if [ "${LOCAL_CLOUDFLARE}" = "True" ] | [ "$LOCAL_CLOUDFLARE" = "true" ]; then
    if [ ! -z "${PINGER}" ]; then
        gunicorn main:app &
        python3 /usr/src/app/.bin/pinger.py &
        wrangler dev --port 31146
    else
        gunicorn main:app &
        wrangler dev --port 31146
    fi
else
    if [ ! -z "${PINGER}" ]; then
        gunicorn main:app &
        python3 /usr/src/app/.bin/pinger.py
    else
        gunicorn main:app
    fi
fi
