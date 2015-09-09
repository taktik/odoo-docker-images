# Ubuntu Docker image

This image is our customized Ubuntu image, based on ubuntu:12.04, serving as a base to many of our other images.  
See [our ubuntu commons scripts](https://github.com/taktik/odoo-docker-commons/tree/master/ubuntu) for more informations.

## Build

    docker build -t docker.taktik.be/odoo/ubuntu https://github.com/taktik/odoo-docker.git#:ubuntu
