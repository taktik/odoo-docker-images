#!/bin/bash

if [ -f /root/.ssh/authorized_keys ]; then
    chown -R root: /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

# start all the services
exec /usr/bin/supervisord -n
