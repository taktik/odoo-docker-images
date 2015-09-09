#!/bin/bash

set -x
set -e

# Get etcd container informations
export ETCD=${ETCD:-false}
export NGINX_NO_DEFAULT_SERVER=${NGINX_NO_DEFAULT_SERVER:-false}

# Persist them in the .profile file
echo "export ETCD=$ETCD" >> /root/.bashrc
echo "export NGINX_NO_DEFAULT_SERVER=$NGINX_NO_DEFAULT_SERVER" >> /root/.bashrc

if [ "$ETCD" != "false" ]; then
    # Link to an etcd container was specified, configure and start ETCD.
    echo "[nginx] starting ETCD: $ETCD."

    echo "[nginx] creating ETCD odoo directory if not existing."
    etcdctl -C "$ETCD" mkdir /hosts || echo "hosts directory already exists in etcd";

    echo "[nginx] creating ETCD nginx directory if not existing."
    etcdctl -C "$ETCD" mkdir /nginx || echo "nginx directory already exists in etcd";

    if [ "$NGINX_NO_DEFAULT_SERVER" != "false" ]; then
        etcdctl -C "$ETCD" set "/nginx/no_default_server" "true" 2>&1 1> /dev/null
    fi

    # Try to make initial configuration every 5 seconds until successful
    #until confd -onetime -node $ETCD; do
    #    echo "[nginx] waiting for confd to create initial nginx configuration."
    #    sleep 5
    #done

    echo "Adding confd to supervisord"
    cat > /etc/supervisor/conf.d/supervisor_confd.conf <<EOF

[program:confd]
command=/usr/local/bin/confd -interval 10 -node $ETCD
autorestart=true
stdout_events_enabled=true
stderr_events_enabled=true
redirect_stderr=true
stdout_logfile=/var/log/confd.log
stdout_logfile_maxbytes=20MB
stdout_logfile_backups=5
stderr_logfile_maxbytes=20MB
stderr_logfile_backups=5

EOF

    echo "Confd added to supervisord"
else
    echo "No link to an etcd container found. Confd will not be started."
fi
