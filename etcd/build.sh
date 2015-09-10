#!/bin/bash

set -x
set -e

# Custom
cd /build
source etcd.sh

# Clean Ubuntu temporary files
curl -s https://raw.githubusercontent.com/taktik/odoo-docker/master/ubuntu/cleanup.sh | sh
