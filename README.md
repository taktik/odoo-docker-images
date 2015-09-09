# odoo-docker

This repository contains a collection of docker images.

## Build

Each directory in this repository contains a Dockerfile, and can thus be built using the command:

    docker build -t docker.taktik.be/odoo/{directory} https://github.com/taktik/odoo-docker.git#:{directory}
