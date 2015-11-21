# Rsync Docker image

This container connects through SSH to the [rsync_host](../rsync_host/readme.md) container and rsyncs the specified directory
into its own /sync directory (specify it through an environment variable, see below).  
To persist the synced datas, you can share this /sync directory with the host.  
Let's say we want to store everything on the host in the /data/synced directory:

    - "/data/synced:/sync"
    
## Environment variables

You can configure some parameters with the following environment variables that you can define when launching the container:

- RSYNC_PATTERN  
the pattern of the files to be copied. Default is *.dump.
- RSYNC_FROM  
the host and directory to rsync the contents from. For instance: root@10.0.2.11:/sync
- RSYNC_FROM_PORT  
the port to use when connecting. Default is 22.
- RSYNC_HOUR  
The hour that will be used in the cron, default is */3 (meaning every three hours).
- RSYNC_MINUTE  
The minute that will be used in the cron. Default is 0.
- RSYNC_BWLIMIT  
set a bandwidth limit (in kb/s).
- DAYS_TO_KEEP  
The number of days to keep the copied files. Default is 30.
- DAYS_TO_KEEP_WEEKLY  
The number of days to keep "weekly" copied files (-weekly in the name). Default is 90.
- DAYS_TO_KEEP_MONTHLY
The number of days to keep "monthly" copied files (-monthly in the name). Default is 365.
The number of days to keep the .dump files (that are not weekly nor monthly). Default is 30.
- SUMMARY_MAIL_TO  
If set, a summary mail will be sent every day to the address(es) specified.  
You can specify multiple addresses by separating them with a comma (or a semicolon).
- SUMMARY_MAIL_HOUR  
If SUMMARY_MAIL_TO is set, you can also specify the hour at which the mail will be sent.

## RSA Keys

In order to be able to connect to the rsync_host container, you can mount a key in /keys/id_rsa_rsync with a volume.

## Logstash-forwarder

To activate logstash-forwarder, the configuration file must be present at /etc/logstash-forwarder.conf (see [logstash-forwarder documentation](https://github.com/taktik/odoo-docker-commons/tree/master/logstash_forwarder)).

