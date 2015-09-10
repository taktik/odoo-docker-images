#!/bin/bash

set -x
set -e

# Ubuntu base config
source /build/setup.sh

# Supervisor
source /commons/supervisord/setup.sh

# SSH Server
source /commons/openssh-server/setup.sh

# ETCD
source /commons/etcd/setup.sh

# Custom
source /build/custom.sh

# Clean Ubuntu temporary files
source /build/cleanup.sh
