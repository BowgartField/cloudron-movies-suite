#!/bin/bash

set -eu

dir=/app/data/config/library
if [[ ! -e $dir ]]; then
    mkdir $dir
fi

if [[ ! -e $dir/metadata.db  ]]; then
    touch $dir/metadata.db
fi

if [[ ! -e /app/data/config/users.sqlite ]]; then
    mv /app/code/calibre/users.sqlite /app/data/config/users.sqlite
fi

# CREATE database
# printf '%s\n' 1 admin changeme changeme | /app/code/calibre/calibre-server --userdb /app/data/config/users.sqlite --manage-users

echo "Starting Calibre..."
exec /app/code/calibre/calibre-server /app/data/config/library --userdb /app/data/config/users.sqlite --enable-auth --disable-use-bonjour
