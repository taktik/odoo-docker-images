FROM docker.taktik.be/odoo/ubuntu
MAINTAINER David Lefever <dl@taktik.be>

# Sleep after chmod because of a bug: https://github.com/docker/docker/issues/9547

ADD . /build

RUN apt-get update && \
    apt-get -qq install git && \
    mkdir -p /commons && \
    git clone https://github.com/taktik/odoo-docker-commons.git /commons

RUN chmod -R +x /build && \
    sleep 2 && \
    /build/build.sh && \
    rm -rf /build && \
    rm -rf /commons;

CMD ["/start.sh"]
