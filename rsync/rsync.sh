#!/bin/bash

RSYNC_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`

cp /build/scripts/start.sh /
cp /build/scripts/start_persist_env_vars.sh /
cp /build/scripts/rsync.sh /
cp /build/scripts/summary_mail.sh /
chmod +x /*.sh

mkdir -p /keys/
mkdir -p /root/.ssh
mkdir -p /var/log/rsync

# SSH config
cp /build/templates/ssh_config /root/.ssh/config

# Logrotate
cp /build/templates/rsync_logrotate /etc/logrotate.d/rsync

# Sendemail
apt-get update
apt-get -yy install sendemail libio-socket-ssl-perl
