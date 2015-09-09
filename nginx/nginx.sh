#!/bin/bash

NGINX_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`

apt-get update
apt-get -qq install apache2-utils # To have htpasswd available

# Confd
curl -L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o /usr/local/bin/confd
chmod +x /usr/local/bin/confd

mkdir -p /etc/confd/conf.d
mkdir -p /etc/confd/templates
mkdir -p /nginx_error_pages
mkdir -p /etc/ssl

# Copy scripts and templates
cp /build/scripts/start.sh /
cp /build/scripts/start_confd.sh /
cp /build/scripts/test_confd.sh /
cp /build/templates/nginx_logrotate /etc/logrotate.d/nginx
cp /build/templates/500.html /nginx_error_pages/

chmod +x /*.sh
