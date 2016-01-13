# odoo-docker

This repository contains a collection of docker images.

## Build

Each directory in this repository contains a Dockerfile, and can thus be built using the command:

    docker build -t docker.taktik.be/odoo/{directory} https://github.com/taktik/odoo-docker.git#:{directory}

## Alpine Linux

Some images use Alpine Linux (to minimize their size, and also for the security it provides).  

### Filebeat 

We had to compile filebeat (old logstash-forwarder), to do so:

First run an interpreter inside an Alpine container:

    docker run -ti --name test --rm gliderlabs/alpine sh
    
Then:

    apk-install build-base bash go git
    export GOROOT=/usr/lib/go
    export GOPATH=/gopath
    export GOBIN=/gopath/bin
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    wget https://github.com/elastic/beats/archive/v1.0.1.tar.gz
    tar -xzvf v1.0.1.tar.gz
    cd beats-1.0.1
    mkdir -p /gopath/src/github.com/elastic/beats/
    mv * /gopath/src/github.com/elastic/beats/
    cd /gopath/src/github.com/elastic/beats/filebeat/
    make
