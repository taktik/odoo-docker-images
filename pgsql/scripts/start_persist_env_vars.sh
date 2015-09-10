#!/bin/bash
#
# This script simply persist some environment variables in /root/.profile
#

# Persist pgsql environment variables
PGSQL=$(printenv | grep -i "^PG");
if [ -n "$PGSQL" ]; then
    while read -r line; do
        echo "export $line" >> /root/.profile
    done <<< "$PGSQL"
fi

# Persist slave environment variables
SLAVE=$(printenv | grep -i "^SLAVE");
if [ -n "$SLAVE" ]; then
    while read -r line; do
        echo "export $line" >> /root/.profile
    done <<< "$SLAVE"
fi

export BACKUPS=${BACKUPS:-true}
echo "export BACKUPS=$BACKUPS" >> /root/.profile

echo "export TERM=xterm" >> /root/.profile

# Reload .profile
source /root/.profile
