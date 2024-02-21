#!/bin/sh

set -eu

echo "Starting Prowlarr..."
exec /app/code/prowlarr/Prowlarr/Prowlarr -nobrowser -data=/app/data/config/