#!/bin/bash

ETCD_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`

cp /build/templates/supervisor_etcd.conf /etc/supervisor/conf.d/
cp /build/scripts/etcd_reset.sh /
cp /build/scripts/start.sh /
chmod +x /*.sh
