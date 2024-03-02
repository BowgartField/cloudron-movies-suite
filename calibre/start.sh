#!/bin/bash

set -eu

dir=/app/data/config/library
if [[ ! -e $dir ]]; then
    mkdir $dir
fi

if [[ ! -e $dir/metadata.db  ]]; then
    touch $dir/metadata.db
fi


echo "Starting Calibre..."
exec /app/code/calibre/calibre-server /app/data/config/library --disable-use-bonjour
