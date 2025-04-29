#!/bin/sh

set -eu

echo "Starting Bazarr..."
exec /app/code/bazarr/Bazarr/Bazarr -nobrowser -data=/app/data/config/