#!/bin/sh

set -eu

echo "Starting Bazarr..."

# Start Bazarr
exec python3 /app/code/bazarr/bazarr.py --config=/app/data/config