#!/bin/bash

set -eu

config_path=/app/data/config/config.conf
# Create the directory if it doesn't exist
if [[ ! -e $config_path ]]; then
    mv /tmp/config.conf $config_path
fi

chown -R cloudron:cloudron /app/data/config/config.conf

db_path=/app/data/config/library

# Get "db_path" var from the config file
. /app/data/config/config.conf

# Create the directory if it doesn't exist
if [[ ! -e $db_path ]]; then
    mkdir $db_path
fi

if [[ ! -e $db_path/metadata.db  ]]; then
    touch $db_path/metadata.db
fi

if [[ ! -e /app/data/config/users.sqlite ]]; then
    mv /tmp/users.sqlite /app/data/config/users.sqlite
fi

# CREATE database
# printf '%s\n' 1 admin changeme changeme | /app/code/calibre/calibre-server --userdb /app/data/config/users.sqlite --manage-users

echo "Starting Calibre..."
exec /app/code/calibre/calibre-server $db_path --userdb /app/data/config/users.sqlite --enable-auth --disable-use-bonjour
