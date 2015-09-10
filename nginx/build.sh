#!/bin/bash

set -x
set -e

# Nginx
source /commons/nginx/setup.sh

# Logstash-forwarder
source /commons/logstash_forwarder/setup.sh

# Custom
cd /build
source nginx.sh

# Clean Ubuntu temporary files
curl -s https://raw.githubusercontent.com/taktik/odoo-docker/master/ubuntu/cleanup.sh | sh