# Nginx Docker image

This image allows us to redirect traffic to the different services of the same server automatically.  
We use Nginx as a reverse proxy, that is automatically configured based on the configuration of the
services stored in ETCD, if the link to etcd is set.

The image can be used as a simple nginx.
You can simply define a volume to /etc/nginx/sites-enabled/

## Build

    docker build -t docker.taktik.be/odoo/ubuntu https://github.com/taktik/odoo-docker.git#:nginx

## Confd and ETCD

Confd is a little tool that listen for changes on specified keys in ETCD and generates a file based on a template.  
We use it to generate the nginx site-enabled.  
To use it, you have to specify the etcd IP (with the environment variable ETCD) and then you can simply mount a volume on /etc/confd/.  
The mounted directory must contain two folders:

- conf.d, containing the confd configuration files (.toml)
- templates, containing the templates

There are two example files in the [examples](examples) folder.  
In our example, we listen on the /hosts directory of ETCD.  
The template then needs the following key/values:

* /hosts/nameofyourservice/ip  
The internal ip of your container
* /hosts/nameofyourservice/config/0/external_port  
The port that nginx should listen on, for instance 80
* /hosts/nameofyourservice/config/0/internal_port  
The port of your service, for instance 80, or 8069 for Odoo
* /hosts/nameofyourservice/config/0/hostnames  
The hostnames nginx should listen on. You can put multiple hostnames separated by a comma.

## Logstash-forwarder

To activate logstash-forwarder, the configuration file must be present at /etc/logstash-forwarder.conf (see [Logstash Forwarder](https://github.com/taktik/odoo-docker-commons/tree/master/logstash_forwarder) readme).

## Important directories

- /etc/nginx/sites-enabled/ where the nginx conf files are stored
