#!/bin/bash

set -x
set -e

echo "[nginx] booting container."

/start_confd.sh

# start all the services
exec /usr/local/bin/supervisord -c /etc/supervisord.conf -n
