#!/bin/bash

# Function to handle keyboard interrupt
function ctrl_c {
    echo -e "\nKilling container!"
    # Add your cleanup actions here
    exit 0
}
# Register the keyboard interrupt handler
trap ctrl_c SIGTERM SIGINT SIGQUIT SIGHUP

mkdir /app/data/cache;
mkdir /app/data/logs;

#ln -s /app/data/characters /app/code/text-generation-webui/characters \
#    && ln -s /app/data/loras /app/code/text-generation-webui/loras \
#    && ln -s /app/data/models /app/code/text-generation-webui/models \
#    && ln -s /app/data/presets /app/code/text-generation-webui/presets \
#    && ln -s /app/data/prompts /app/code/text-generation-webui/prompts \
#    && ln -s /app/data/training /app/code/text-generation-webui/training \
#    && ln -s /app/data/logs /app/code/text-generation-webui/logs \
#    && ln -s /app/data/cache /app/code/text-generation-webui/cache;

# Generate default configs if empty
CONFIG_DIRECTORIES=("characters" "extensions" "loras" "models" "presets" "prompts" "training" "training/datasets" "training/formats")
for config_dir in "${CONFIG_DIRECTORIES[@]}"; do
  if [ ! -e "/app/data/"$config_dir ]; then
    echo "*** Initialising config for: '$config_dir' ***"
    mkdir /app/data/$config_dir;
    cp -ar /tmp/config/"$config_dir"/* /app/data/"$config_dir"/
    # chown -R 1000:1000 /app/code/text-generation-webui/"$config_dir"  # Not ideal... but convenient.
  fi
done

# Populate extension folders if empty
EXTENSIONS_SRC="/tmp/config/extensions"
EXTENSIONS_DEFAULT=($(find "$EXTENSIONS_SRC" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
for extension_dir in "${EXTENSIONS_DEFAULT[@]}"; do
  if [ ! -e "/app/data/extensions/"$extension_dir ]; then
    echo "*** Initialising extension: '$extension_dir' ***"
    mkdir -p /app/data/extensions/"$extension_dir"
    cp -ar "$EXTENSIONS_SRC"/"$extension_dir"/* /app/data/extensions/"$extension_dir"/
  fi
done
# chown -R 1000:1000 /app/code/text-generation-webui/extensions  # Not ideal... but convenient.

# Runtime extension build
# if [[ -n "$BUILD_EXTENSIONS_LIVE" ]]; then
#  eval "live_extensions=($BUILD_EXTENSIONS_LIVE)"
#  . /scripts/extensions_runtime_rebuild.sh $live_extensions
# fi

# Print variant
VARIANT=$(cat /variant.txt)
VERSION_TAG_STR=$(cat /version_tag.txt)
echo "=== Running text-generation-webui variant: '$VARIANT' $VERSION_TAG_STR ===" 

# Print version freshness
cur_dir=$(pwd)
src_dir="/src"
cd $src_dir
git fetch origin >/dev/null 2>&1
if [ $? -ne 0 ]; then
  # An error occurred
  COMMITS_BEHIND="UNKNOWN"
else
  # The command executed successfully
  COMMITS_BEHIND=$(git rev-list HEAD..main --count)
fi
echo "=== (This version is $COMMITS_BEHIND commits behind origin main) ===" 
cd $cur_dir

# Print build date
BUILD_DATE=$(cat /build_date.txt)
echo "=== Image build date: $BUILD_DATE ==="

cd /app/code/text-generation-webui/
exec python3 -u server.py --disk-cache-dir /app/data/cache --listen --gradio-auth-path /app/data/config/auth.conf
