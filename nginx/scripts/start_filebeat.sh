#!/bin/bash
#
# Start filebeat only if configuration file /etc/filebeat/filebeat.yml was found.
#

if [ ! -f "/etc/filebeat/filebeat.yml" ]; then
        echo "Configuration file /etc/filebeat/filebeat.yml not found, exiting"
        exit 3; # Special exit code (in allowed exitcodes of supervisod configuration file).
else
    mkdir -p /home/filebeat
    exec /usr/local/bin/filebeat -c /etc/filebeat/filebeat.yml
fi
