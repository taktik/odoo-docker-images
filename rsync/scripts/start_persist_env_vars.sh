#!/bin/bash
#
# This script simply persist some environment variables in /root/.bashrc
#

# Rsync variables
RSYNC=$(printenv | grep -i "RSYNC");
if [ -n "$RSYNC" ]; then
    while read -r line; do
        echo "export $line" >> /root/.profile
    done <<< "$RSYNC"
fi

export DAYS_TO_KEEP=${DAYS_TO_KEEP:-30}
export DAYS_TO_KEEP_WEEKLY=${DAYS_TO_KEEP_WEEKLY:-90}
export DAYS_TO_KEEP_MONTHLY=${DAYS_TO_KEEP_MONTHLY:-365}
echo "export DAYS_TO_KEEP=$DAYS_TO_KEEP" >> /root/.profile
echo "export DAYS_TO_KEEP_WEEKLY=$DAYS_TO_KEEP_WEEKLY" >> /root/.profile
echo "export DAYS_TO_KEEP_MONTHLY=$DAYS_TO_KEEP_MONTHLY" >> /root/.profile

echo "export TERM=xterm" >> /root/.profile

# Reload .profile
source /root/.profile
