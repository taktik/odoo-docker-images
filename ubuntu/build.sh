#!/bin/bash

set -x
set -e

# Ubuntu base config
source /commons/ubuntu/setup.sh

# Supervisor
source /commons/supervisord/setup.sh

# SSH Server
source /commons/openssh-server/setup.sh
cp /commons/openssh-server/templates/supervisor_sshd.conf /etc/supervisor/conf.d/

# ETCD
source /commons/etcd/setup.sh

# Custom
cd /build
source ubuntu.sh

# Clean Ubuntu temporary files
source /commons/ubuntu/cleanup.sh
