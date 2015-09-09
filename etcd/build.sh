#!/bin/bash

set -x
set -e

# Custom
cd /build
source etcd.sh

# Clean Ubuntu temporary files
source /commons/ubuntu/cleanup.sh
