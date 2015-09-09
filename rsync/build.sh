#!/bin/bash

set -x
set -e

# Logstash-forwarder
source /commons/logstash_forwarder/setup.sh

# Custom
cd /build
source rsync.sh

# Clean Ubuntu temporary files
source /commons/ubuntu/cleanup.sh
