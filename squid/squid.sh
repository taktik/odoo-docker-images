#!/bin/bash

apt-get update
apt-get -qq install devscripts build-essential fakeroot libssl-dev

wget http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.8.tar.gz
tar -xzvf squid-3.5.8.tar.gz
cd squid-3.5.8

./configure --enable-ssl \
--with-openssl \
--enable-ssl-crtd \
--datadir=/usr/share/squid3 \
--sysconfdir=/etc/squid3

make all
make install

mkdir -p /usr/local/squid/var/lib/
mkdir -p /var/cache/squid3/
mkdir -p /var/spool/squid3

chown -R proxy: /etc/squid3
chown -R proxy: /usr/local/squid
chown -R proxy: /var/cache/squid3/
chown -R proxy: /var/spool/squid3

/usr/local/squid/libexec/ssl_crtd -c -s /usr/local/squid/var/lib/ssl_db 2>&1 > /dev/null || true
chown -R proxy /usr/local/squid/var/lib/ssl_db

cp /build/scripts/start.sh /
chmod +x /*.sh
