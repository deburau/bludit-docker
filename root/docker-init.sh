#!/bin/sh
set -e

# first arg not empty and is not `-f` or `--some-option`
if [ -n "$1" -a "${1#-}" = "$1" ]; then
    exec "$@"
fi

export TARGET_PATH="/usr/share/nginx/html/"

echo "[+] docker-init.sh for bludit"
echo "  - Webroot: ${TARGET_PATH}"

# Execute all scripts in /docker-init.d/
for file in /docker-init.d/*; do
  [ -f "${file}" ] && source "${file}" "$@"
done
