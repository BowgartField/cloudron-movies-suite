#!/bin/sh

set -eu

echo "Starting Bazarr..."

# Create directories in /app/config if they don't exist
mkdir -p /app/config/data
mkdir -p /app/config/logs
mkdir -p /app/config/config

# Ensure proper permissions
chown -R cloudron:cloudron /app/config

# Start Bazarr
exec python3 /app/code/bazarr/bazarr.py