#!/bin/sh

set -eu

echo "Starting Readarr..."
exec /app/code/readarr/Readarr/Readarr -nobrowser -data=/app/data/config/