#!/bin/bash

SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`

# Logrotate cron
crontab -l 2> /dev/null > /cron_tmp || true # Dump current crontab to file
sed -i "/logrotate/d" /cron_tmp # Delete previous line if it existed
echo "0 1 * * * /usr/sbin/logrotate /etc/logrotate.conf > /dev/null 2>&1" >> /cron_tmp
crontab /cron_tmp
rm /cron_tmp
