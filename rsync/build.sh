#!/bin/bash

set -x
set -e

RSYNC_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`

cp /build/scripts/start.sh /
cp /build/scripts/start_persist_env_vars.sh /
cp /build/scripts/start_logstash_forwarder.sh /
cp /build/scripts/rsync.sh /
cp /build/scripts/logstash-forwarder /usr/local/bin/
chmod +x /*.sh
chmod +x /usr/local/bin/logstash-forwarder

mkdir -p /keys/
mkdir -p /root/.ssh
mkdir -p /var/log/rsync
mkdir -p /var/log/supervisor

# SSH config
cp /build/templates/ssh_config /root/.ssh/config

# Logrotate
cp /build/scripts/logrotate.sh /etc/periodic/hourly/
cp /build/templates/rsync_logrotate /etc/logrotate.d/rsync
chmod -R 644 /etc/logrotate.d/

# Logstash supervisord config
mkdir -p /etc/supervisor.d/
cp /build/templates/supervisor_*.ini /etc/supervisor.d/
