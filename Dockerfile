FROM ubuntu:20.04

WORKDIR /usr/src/app

RUN chmod 777 /usr/src/app

RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends python3.9 && \
    apt-get -qq install -y --no-install-recommends python3.9-dev && \
    apt-get -qq install -y --no-install-recommends python3-pip && \
    apt-get -qq install -y curl

RUN curl -O -s https://raw.githubusercontent.com/libDrive/server/main/requirements.txt && \
    pip3 install -r requirements.txt -q --no-cache-dir

ENV PATH="/usr/src/app/.local/bin:${PATH}"

COPY . .

RUN chmod +x start.sh
