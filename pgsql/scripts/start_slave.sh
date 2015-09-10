#!/bin/bash
#
# This script will be called from supervisor (it is added from start_postgresql.sh).
# If the environment variables SLAVE_MASTER_IP and SLAVE_MASTER_REPLICATOR_PASSWORD are set,
# the instance will be configured to be a slave instance.
# To promote it, create the file /tmp/postgresql.trigger
# When the script is launched, the instance is stopped,
# ALL THE DATAS ARE REMOVED,
# then a backup is copied from the master instance and the instane is relaunched.
#

set -e

SLAVEPORT=${SLAVEPORT:-5432}
SLAVEUSER=${SLAVEUSER:-false}

if [ -n "$PGSQL_HOT_STANDBY" ] && [ "$PGSQL_HOT_STANDBY" != "false" ]; then

    if [ -z "$SLAVEHOST" ] || [ "$SLAVEHOST" == "false" ]; then
        echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Environment variable SLAVEHOST not defined."
        exit 3;
    fi

    if [ -z "$SLAVEUSER" ] || [ "$SLAVEUSER" == "false" ]; then
        SLAVEUSER="replicator"
    fi

    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Stopping PostgreSQL"
    supervisorctl stop postgresql
    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Starting slave process from /start_slave.sh (check psql_slave.log)" >> /var/log/postgresql.log

    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Cleaning up old cluster directory"
    sudo -u postgres rm -rf /var/lib/postgresql/9.3/main/*

    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Starting base backup as replicator"
    sudo -u postgres PGPASSWORD="$SLAVEPASSWORD" PGUSER="$SLAVEUSER" pg_basebackup -h "$SLAVEHOST" -p "$SLAVEPORT" -D /var/lib/postgresql/9.3/main -v -P

    # Fix access rights
    chown -R postgres: /var/lib/postgresql/9.3/main
    chmod 700 /var/lib/postgresql/9.3/main
    chown -R postgres: /run/postgresql
    chmod 775 /run/postgresql

    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Writing recovery.conf file"
    sudo -u postgres bash -c "cat > /var/lib/postgresql/9.3/main/recovery.conf <<- _EOF1_
standby_mode = 'on'
primary_conninfo = 'host=$SLAVEHOST port=$SLAVEPORT user=$SLAVEUSER password=$SLAVEPASSWORD sslmode=require'
trigger_file = '/tmp/postgresql.trigger'
_EOF1_
"
    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Slave process finished" >> /var/log/postgresql.log
    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Slave process finished"
    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Starting PostgreSQL"
    supervisorctl start postgresql

    # Replication status log
    crontab -l 2> /dev/null > /cron_tmp || true # Dump current crontab to file
    sed -i "/pgReplicationStatus.sh/d" /cron_tmp # Delete previous line if it existed
    echo "* * * * * /usr/local/bin/pgReplicationStatus.sh >> /var/log/pg_replication.log" >> /cron_tmp
    crontab /cron_tmp
    rm /cron_tmp

else
    echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Environment variable SLAVE is empty (should be other than false)"
    exit 3
fi
