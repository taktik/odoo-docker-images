#!/bin/bash
#
# Start logstash-forwarder only if configuration file /etc/logstash-forwarder.conf was found.
#

if [ ! -f "/etc/logstash-forwarder.conf" ]; then
        echo "Configuration file /etc/logstash-forwarder.conf not found, exiting"
        exit 3; # Special exit code (in allowed exitcodes of supervisod configuration file).
else
    exec /usr/local/bin/logstash-forwarder -config /etc/logstash-forwarder.conf
fi
