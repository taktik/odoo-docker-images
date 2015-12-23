FROM gliderlabs/alpine:3.2
MAINTAINER David Lefever <dl@taktik.be>

ADD . /build
RUN apk-install supervisor rsync bash logrotate openssh
RUN chmod -R +x /build && \
    sleep 2 && \
    /build/build.sh && \
    rm -rf /build;

CMD ["/start.sh"]
