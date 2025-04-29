#!/bin/sh

set -eu

echo "Starting Bazarr..."

# Create directories in /app/config if they don't exist
mkdir -p /app/config/data
mkdir -p /app/config/logs
mkdir -p /app/config/config

# Remove existing directories in /app/code/bazarr if they exist
rm -rf /app/code/bazarr/data
rm -rf /app/code/bazarr/logs
rm -rf /app/code/bazarr/config

# Create symlinks to /app/config directories
ln -sf /app/config/data /app/code/bazarr/data
ln -sf /app/config/logs /app/code/bazarr/logs
ln -sf /app/config/config /app/code/bazarr/config

# Ensure proper permissions
chown -R cloudron:cloudron /app/config

# Start Bazarr
exec python3 /app/code/bazarr/bazarr.py