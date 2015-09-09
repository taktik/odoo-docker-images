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

# SMTP variables
SMTP=$(printenv | grep -i "SMTP");
if [ -n "$SMTP" ]; then
    while read -r line; do
        echo "export $line" >> /root/.profile
    done <<< "$SMTP"
fi

export DAYS_TO_KEEP=${DAYS_TO_KEEP:-30}
export SUMMARY_MAIL_TO=${SUMMARY_MAIL_TO:-false}
export SUMMARY_MAIL_HOUR=${SUMMARY_MAIL_HOUR:-7}
echo "export DAYS_TO_KEEP=$DAYS_TO_KEEP" >> /root/.profile
echo "export SUMMARY_MAIL_TO=$SUMMARY_MAIL_TO" >> /root/.profile
echo "export SUMMARY_MAIL_HOUR=$SUMMARY_MAIL_HOUR" >> /root/.profile

echo "export TERM=xterm" >> /root/.profile

# Reload .profile
source /root/.profile
