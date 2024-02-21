#!/bin/sh

set -eu

echo "Starting Radarr..."
exec /app/code/radarr/Radarr/Radarr -nobrowser -data=/app/data/config/