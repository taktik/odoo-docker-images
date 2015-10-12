#!/bin/bash
#
# This script will be executed when the container starts.
# It will initialize a postgreSQL instance if needed, and
# tweak the parameters in postgresql.conf.
#

# Fix access rights
chown -R postgres: /var/lib/postgresql/9.3/main
chmod 700 /var/lib/postgresql/9.3/main
chown -R postgres: /run/postgresql
chmod 775 /run/postgresql

# Initdb if directory empty
if [ ! "$(ls -A /var/lib/postgresql/9.3/main)" ]; then
    echo "[odoo] directory /var/lib/postgresql/9.3/main empty, launching initdb"
    su postgres -c "/usr/lib/postgresql/9.3/bin/initdb -E utf8 --locale=en_US.UTF-8 /var/lib/postgresql/9.3/main"

    # Create openerp role
    echo "[odoo] creating openerp role and database"
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'CREATE USER openerp WITH CREATEDB NOCREATEUSER;'"
    # Create openerp database
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'CREATE DATABASE openerp WITH OWNER openerp;'"
    # Create replicator role
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'CREATE USER replicator REPLICATION LOGIN;'"
    # Create collectd role
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'CREATE USER collectd WITH NOCREATEDB NOCREATEUSER;'"
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'ALTER USER collectd set default_transaction_read_only = on;'"
fi

# Modify passwords if OPENERP_PGSQL_PASSWD or REPLICATOR_PGSQL_PASSWD are specified
if [ -n "$OPENERP_PGSQL_PASSWD" ] && [ "$OPENERP_PGSQL_PASSWD" != "false" ]; then
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'ALTER ROLE openerp WITH PASSWORD '\''$OPENERP_PGSQL_PASSWD'\'';'"
fi
if [ -n "$REPLICATOR_PGSQL_PASSWD" ] && [ "$REPLICATOR_PGSQL_PASSWD" != "false" ]; then
    su postgres -c "/usr/lib/postgresql/9.3/bin/postgres --single -c config-file=/etc/postgresql/9.3/main/postgresql.conf <<< 'ALTER ROLE replicator WITH ENCRYPTED PASSWORD '\''$REPLICATOR_PGSQL_PASSWD'\'';'"
fi

# Hot standby (or slave) configuration
if ! grep -q "ssl = on" /etc/postgresql/9.3/main/postgresql.conf; then # Some containers already have wal_level, max_wal_senders, etc.
    # Configure PostgreSQL to be hot_standby (to be able to connect a slave).
    # See http://www.rassoc.com/gregr/weblog/2013/02/16/zero-to-postgresql-streaming-replication-in-10-mins/
    sudo -u postgres bash -c "cat >> /etc/postgresql/9.3/main/postgresql.conf <<- _EOF1_
wal_level = hot_standby
max_wal_senders = 3
checkpoint_segments = 8
wal_keep_segments = 32
ssl = on
ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'		# (change requires restart)
ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'		# (change requires restart)
_EOF1_
"
fi

# Tune Postgresql (every environment variable starting with PGSQL_ will be put in postgresql.conf (without PGSQL_, in lower case)
PGSQL=$(printenv | grep "^PGSQL");
if [ -n "$PGSQL" ]; then
    while read -r line; do
        IFS='=' read -a pgsqlvar <<< "$line" # Split line on =
        option=$(echo "${pgsqlvar[0]}" | sed -r 's/PGSQL_//' | tr '[:upper:]' '[:lower:]') # Remove ODOO_ and keep only the option name (ODOO_DB_HOST => DB_HOST)
        value="${pgsqlvar[1]}"
        sed -i "/^$option =.*/d" /etc/postgresql/9.3/main/postgresql.conf # Delete previous line if it existed
        sudo -u postgres bash -c "echo \"$option = $value\" >> /etc/postgresql/9.3/main/postgresql.conf"
    done <<< "$PGSQL"
fi

# https://github.com/nimiq/docker-postgresql93/pull/4/files
# Bug with aufs and SSL certificates.
mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

# Be sure these files exist
mkdir -p /run/postgresql/9.3-main.pg_stat_tmp
touch /run/postgresql/9.3-main.pg_stat_tmp/global.tmp
chown -R postgres: /var/run/postgresql/
