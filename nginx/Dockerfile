FROM gliderlabs/alpine:3.2
MAINTAINER David Lefever <dl@taktik.be>

ADD . /build
RUN apk-install supervisor bash logrotate
RUN chmod -R +x /build && \
    sleep 2 && \
    /build/build.sh && \
    rm -rf /build;

CMD ["/start.sh"]
