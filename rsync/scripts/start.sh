#!/bin/bash

source /start_persist_env_vars.sh
RSYNC_MINUTE=${RSYNC_MINUTE:-20}
RSYNC_HOUR=${RSYNC_HOUR:-*/3}

if [ ! -f "/keys/id_rsa_rsync" ]; then
    echo "You should mount a private key in /keys/id_rsa_rsync"
    echo "and allow it in the rsync_host container via the authorized_keys"
    exit 1
fi

chown root: /keys/id_rsa_rsync
chmod 600 /keys/id_rsa_rsync

echo "Starting rsync" >> /var/log/rsync/rsync.log
/rsync.sh | tee /var/log/rsync/rsync.log

# Rsync crontab
crontab -l 2> /dev/null > /cron_tmp || true # Dump current crontab to file
sed -i "/rsync.sh/d" /cron_tmp # Delete previous line if it existed
echo "$RSYNC_MINUTE $RSYNC_HOUR * * * /rsync.sh >> /var/log/rsync/rsync.log 2> /var/log/rsync/error.log" >> /cron_tmp
crontab /cron_tmp
rm /cron_tmp

# start all the services
exec /usr/bin/supervisord -n
