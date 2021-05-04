#!/bin/bash

cd /usr/src/app

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

get_host() {
	local host
	host=$(hostname -A)
	echo "$host:$PORT" | tr -d " "
}

auto_pinger() {
	host=$(get_host)
    gunicorn main:app &
	P1=$!
	while :; do
		sleep 600
		curl -s "$host/api/v1/ping"
	done &
	P2=$!
	wait $P1 $P2
}

if [ "${LIBDRIVE_PINGER}" = "true" ]; then
	auto_pinger
else
    gunicorn main:app
fi
