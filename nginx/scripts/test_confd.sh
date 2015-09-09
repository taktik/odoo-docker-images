#!/bin/bash

etcdctl --peers $ETCD set "/hosts/192.168.88.66/ip" "192.168.88.66"
etcdctl --peers $ETCD set "/hosts/192.168.88.66/config/0/external_port" "80"
etcdctl --peers $ETCD set "/hosts/192.168.88.66/config/0/internal_port" "8069"
etcdctl --peers $ETCD set "/hosts/192.168.88.66/config/0/hostnames" "local.dev"

etcdctl --peers $ETCD set "/hosts/192.168.88.88/ip" "192.168.88.88"
etcdctl --peers $ETCD set "/hosts/192.168.88.88/config/0/external_port" "80"
etcdctl --peers $ETCD set "/hosts/192.168.88.88/config/0/internal_port" "8069"
etcdctl --peers $ETCD set "/hosts/192.168.88.88/config/0/hostnames" "local.dev"
etcdctl --peers $ETCD set "/hosts/192.168.88.88/config/0/ssl_certificate" "/tmp/cert.key"
etcdctl --peers $ETCD set "/hosts/192.168.88.88/config/0/ssl_certificate_key" "/tmp/cert.key"

etcdctl --peers $ETCD set "/hosts/192.168.88.77/ip" "192.168.88.77"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/external_port" "80"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/internal_port" "8069"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/hostnames" "local.dev"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/ssl_certificate" "/tmp/cert.key"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/ssl_certificate_key" "/tmp/cert.key"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/ssl_enforce" "1"
etcdctl --peers $ETCD set "/hosts/192.168.88.77/config/0/proxy_read_timeout" "600"

confd -onetime -debug -node $ETCD

cat /etc/nginx/sites-enabled/app.conf