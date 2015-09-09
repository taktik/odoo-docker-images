#!/bin/bash

set -x
set -e

# Custom
cd /build/
source rsync.sh

# Clean Ubuntu temporary files
source /commons/ubuntu/cleanup.sh
