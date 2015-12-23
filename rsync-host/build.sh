#!/bin/bash

set -x
set -e

mkdir -p /root/.ssh
cp /build/scripts/start.sh /
chmod +x /*.sh
mkdir -p /var/log/supervisor

# Set a password on root, even if sshd_config only allows keys
# because it might not work if user has no password
echo -e "rootpwd\nrootpwd\n" | passwd root

# Block password authentication
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Logstash supervisord config
mkdir -p /etc/supervisor.d/
cp /build/templates/supervisor_*.ini /etc/supervisor.d/

# Generating host keys
/usr/bin/ssh-keygen -A
