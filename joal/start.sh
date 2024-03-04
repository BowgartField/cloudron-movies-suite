#!/bin/sh

set -eu

mv /app/code/clients /app/data/clients
mv /app/code/config.json /app/data/config.json
mv /app/code/torrents /app/data/torrents

mv /tmp/config.conf /app/data/config.conf

# get $prefix and $token from config.conf
. /app/data/config.conf

echo "Starting Joal..."
java -jar ./jack-of-all-trades-X.X.X.jar \
--joal-conf="/app/data/" \ 
--spring.main.web-environment=true \
--server.port=8080 \ 
--joal.ui.path.prefix=$prefix \
--joal.ui.secret-token="$token