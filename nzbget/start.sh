#!/usr/bin/env sh
set -e

su -p cloudron -c "/app/code/nzbget/nzbget -s -c /app/data/config/nzbget.conf -o OutputMode=log"
