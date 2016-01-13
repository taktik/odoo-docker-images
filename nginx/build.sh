#!/bin/bash

set -x
set -e

cp /build/scripts/start.sh /
cp /build/scripts/start_confd.sh /
cp /build/scripts/test_confd.sh /
chmod +x /*.sh

mkdir -p /var/log/supervisor
mkdir -p /etc/confd/conf.d
mkdir -p /etc/confd/templates
mkdir -p /nginx_error_pages
mkdir -p /etc/ssl
mkdir -p /etc/supervisor.d/
mkdir -p /etc/nginx

cp /build/templates/supervisor_nginx.ini /etc/supervisor.d/

apk add --update bash build-base ca-certificates openssl openssl-dev tar gzip pcre-dev zlib-dev wget curl

# Confd
curl -L https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64 -o /usr/local/bin/confd
chmod +x /usr/local/bin/confd

# etcd
cd /tmp
curl -L  https://github.com/coreos/etcd/releases/download/v2.2.3/etcd-v2.2.3-linux-amd64.tar.gz -o etcd-v2.2.3-linux-amd64.tar.gz
tar xzvf etcd-v2.2.3-linux-amd64.tar.gz
cd etcd-v2.2.3-linux-amd64
cp etcd /usr/local/bin/etcd
cp etcdctl /usr/local/bin/etcdctl
chmod +x /usr/local/bin/etcd*

# Nginx
# Inspired by https://github.com/connexio-labs/docker-alpine-nginx-dynamic/blob/master/Dockerfile
export NGINX_VERSION="nginx-1.8.0"
apk --update add openssl-dev pcre-dev zlib-dev wget build-base
mkdir -p /tmp/src
cd /tmp/src
wget http://nginx.org/download/${NGINX_VERSION}.tar.gz
tar -zxvf ${NGINX_VERSION}.tar.gz
cd /tmp/src/${NGINX_VERSION}
./configure \
    --sbin-path=/usr/local/sbin/nginx \
    --prefix=/etc/nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log
make
make install

mkdir -p /etc/nginx/sites-enabled/
mkdir -p /etc/nginx/sites-available/
mkdir -p /nginx_error_pages/

cp /build/templates/nginx_logrotate /etc/logrotate.d/nginx
cp /build/templates/500.html /nginx_error_pages/
cp /build/templates/nginx.conf /etc/nginx/conf/nginx.conf

apk del --purge tar openssl
apk del build-base
rm -rf /nginx
rm -rf /tmp/*
rm -rf /var/cache/apk/*
