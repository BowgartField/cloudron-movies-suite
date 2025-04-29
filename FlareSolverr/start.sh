#!/bin/sh

set -eu

mkdir -p "/app/data/chromium/Crash Reports/pending"
mkdir -p "/app/data/cache/share"

FILE=/app/data/config.conf
if [ ! -f "$FILE" ]; then
    cp /tmp/config.conf $FILE
fi
export $(cat $FILE | xargs)

echo "Starting FlareSolverr..."
exec python3 /app/code/flaresolverr/src/flaresolverr.py 
