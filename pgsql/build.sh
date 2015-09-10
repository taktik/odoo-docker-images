#!/bin/bash

set -x
set -e

# PostgreSQL
source /commons/pgsql/setup.sh

# Collectd
source /commons/collectd/setup.sh

# Logstash-forwarder
source /commons/logstash_forwarder/setup.sh

# Custom
source /build/custom.sh

# Clean Ubuntu temporary files
curl -s https://raw.githubusercontent.com/taktik/odoo-docker/master/ubuntu/cleanup.sh | sh