#!/bin/bash

IP=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

echo "[etcd] removing old configuration directories if existing"
rm -Rf /etcd1.etcd

ADVERTISE_CLIENT_URLS=${ADVERTISE_CLIENT_URLS:-false}
echo "export ADVERTISE_CLIENT_URLS=$ADVERTISE_CLIENT_URLS" >> /root/.profile

if [ "$ADVERTISE_CLIENT_URLS" != "false" ]; then
    # Replace supervisor_etcd.conf if a different ADVERTISE_CLIENT_URLS is set
    cat > /etc/supervisor/conf.d/supervisor_etcd.conf <<EOF

[program:etcd]
command=/usr/local/bin/etcd -advertise-client-urls $ADVERTISE_CLIENT_URLS -listen-client-urls http://0.0.0.0:4001 -name etcd1
stdout_events_enabled=true
stderr_events_enabled=true
redirect_stderr=true
stdout_logfile=/var/log/supervisor/etcd.log
stdout_logfile_maxbytes=20MB
stdout_logfile_backups=5
stderr_logfile_maxbytes=20MB
stderr_logfile_backups=5

EOF
fi

echo "[etcd] starting all services"
exec /usr/local/bin/supervisord -n
