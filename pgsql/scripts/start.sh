#!/bin/bash

source /start_persist_env_vars.sh

/start_postgresql.sh

# Slave mode
# Configure PostgreSQL to be hot_standby (to be able to connect a slave).
# See http://www.rassoc.com/gregr/weblog/2013/02/16/zero-to-postgresql-streaming-replication-in-10-mins/
if [ -n "$PGSQL_HOT_STANDBY" ] && [ "$PGSQL_HOT_STANDBY" != "false" ]; then
    # Activate slave supervisord conf
    mv /etc/supervisor/conf.d/supervisor_pgsql_slave.conf.bkp /etc/supervisor/conf.d/supervisor_pgsql_slave.conf
fi

# Backup cron
if [ -z "$BACKUPS" ] || [ "$BACKUPS" != "false" ]; then
    mkdir -p /usr/local/openerp/backups
    crontab -l 2> /dev/null > /cron_tmp || true # Dump current crontab to file
    sed -i "/pg_backup.sh/d" /cron_tmp # Delete previous line if it existed
    echo "0 * * * * /usr/local/bin/pg_backup.sh -c /config/pg_backup/pg_backup.config >> /var/log/pg_backup.log" >> /cron_tmp
    crontab /cron_tmp
    rm /cron_tmp
fi

# start all the services
exec /usr/local/bin/supervisord -n
