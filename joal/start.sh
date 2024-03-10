#!/bin/sh

set -eu

cp -r /app/code/clients /app/data/clients
cp /app/code/config.json /app/data/config.json
cp -r /app/code/torrents /app/data/torrents

cp /tmp/config.conf /app/data/config.conf

# get $prefix and $token from config.conf
. /app/data/config.conf

echo "Starting Joal..."
java -jar /app/code/jack-of-all-trades-2.1.36.jar \
--joal-conf="/app/data/" \ 
--spring.main.web-environment=true \
--server.port=8080 \ 
--joal.ui.path.prefix=$prefix \
--joal.ui.secret-token="$token
