# Squid image

This image contains a squid server.  
It is compiled with SSL support.  

## Configuration

You can mount the configuration file with a shared volume in /etc/squid3/squid.conf  

## Persistence

The cache is located in /var/cache/squid3/.  
You can persist it by sharing this folder with the host.

## Logs

Logs are located in /usr/local/squid/var/logs/.