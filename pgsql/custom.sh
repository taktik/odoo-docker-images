#!/bin/bash

PGSQL_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`

cp /build/scripts/start.sh /
cp /build/scripts/start_persist_env_vars.sh /
cp /build/scripts/start_postgresql.sh /
cp /build/scripts/start_slave.sh /
cp /build/templates/pg_replication_logrotate /etc/logrotate.d/pg_replication_logrotate
cp /build/templates/supervisor_pgsql_slave.conf /etc/supervisor/conf.d/supervisor_pgsql_slave.conf.bkp
chmod +x /*.sh

# Sendemail
apt-get update
apt-get -yy install sendemail libio-socket-ssl-perl
