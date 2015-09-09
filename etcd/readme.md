# etcd Docker image

This image runs an etcd instance.  

## Build

    docker build -t docker.taktik.be/odoo/etcd https://github.com/taktik/odoo-docker.git#:etcd

## Ports

The ports 4001 and 7001 should be open.  
etcd's -listen-client-urls option is set to http://0.0.0.0:4001.

## Environment variables

- $ADVERTISE_CLIENT_URLS  
Set this variable if you want to modify etcd -advertise-client-urls (default is http://172.17.42.1:4001).  
