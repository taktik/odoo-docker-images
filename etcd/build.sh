#!/bin/bash

set -x
set -e

cp /build/scripts/start.sh /
chmod +x /*.sh
mkdir -p /var/log/supervisor

apk add --update ca-certificates openssl tar && \
wget https://github.com/coreos/etcd/releases/download/v2.2.2/etcd-v2.2.2-linux-amd64.tar.gz && \
tar xzvf etcd-v2.2.2-linux-amd64.tar.gz && \
mv etcd-v2.2.2-linux-amd64/etcd* /usr/bin/ && \
apk del --purge tar openssl && \
rm -Rf etcd-v2.2.2-linux-amd64* /var/cache/apk/*
