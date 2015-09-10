#!/bin/bash

/usr/local/squid/sbin/squid -Nz # Create directories if needed
chown -R proxy: /var/cache/squid3
exec /usr/local/squid/sbin/squid -Nd2 # Start squid in foreground
