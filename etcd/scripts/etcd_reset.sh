#!/bin/bash
#
# Remove all directories and keys under /hosts/
#

supervisorctl stop etcd

echo "[etcd] removing old configuration directories if existing"
rm -Rf /etcd1.etcd

supervisorctl start etcd

echo "[nginx] creating ETCD odoo directory if not existing."
etcdctl mkdir /hosts || echo "hosts directory already exists in etcd";

echo "[nginx] creating ETCD nginx directory if not existing."
etcdctl mkdir /nginx || echo "nginx directory already exists in etcd";
