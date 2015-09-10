# Pgsql (PostgreSQL) Docker image

This image contains a PostgreSQL server installation.  
It can be used as a master or a slave, depending on the configuration (environment variables).

Two roles are created at first launch:

- openerp
- collectd

## Environment variables

### To configure PostgreSQL

Every variable starting with **PGSQL_** will be put in the postgresql.conf file (without the PGSQL_ part, in lowercase).   
You can also set variables starting with PG that will be taken into account in PostgreSQL executables (see [http://www.postgresql.org/docs/9.4/static/libpq-envars.html](http://www.postgresql.org/docs/9.4/static/libpq-envars.html)).

- To modify the openerp user password, use OPENERP_PGSQL_PASSWD. 
- To modify the replicator user password, use REPLICATOR_PGSQL_PASSWD.

To configure the postgreSQL to be a slave, you can use:

- SLAVEHOST (ip of the master postgreSQL instance)
- SLAVEPORT (port of the master postgreSQL instance)
- SLAVEUSER (user used to connect to the master, defaults to replicator)
- SLAVEPASSWORD (password of the replicator user on the master)

### To configure PostgreSQL backups

By default, a backup of all the databases will be done each hour in the directory /usr/local/openerp/backups/  
You can mount the configuration file at /config/pg_backup/pg_backup.config if you desire to override it.  
An example of the configuration file can be found in the pgsql commons (https://github.com/taktik/odoo-docker-commons/tree/master/pgsql/templates).  
The following variables are available:

- BACKUPS=false, to deactivate the backups completely
- BACKUP_ONLY_FILTER, allows you to define the databases to backup (every database containing the value in their name). It will override the option from the configuration file.

## Important directories

- PostgreSQL datas: /var/lib/postgresql/9.3/main/
- PostgreSQL backups: /usr/local/openerp/backups/

## Available binaries

- backupDatabase.sh, to dump a database in /usr/local/openerp/backups
- dropAndImportDB.sh, to drop a database and replace it by the specified dump
- pg_backup.sh, to handle backups
- pgClientReplicationStatus.sh, to check the replication status of the clients (slaves)
- pgCreateRole.sh, create the specified role and add it to the openerp role
- pgKillSessions.sh, kill the sessions of the specified database
- pgReplicationStatus, check the replication status (slave)

## PostgreSQL slave, hot standby

All the PostgreSQL instances built into the odoo images are ready to stream their logs to a slave instance.
We only need to publish the 5432 port, for instance in the crane.yml:

	- "10.0.200.11:5432:5432" # PostgreSQL only from VRack
	
This tells that the port 5432 will be accessible only from the VRack (which has the IP 10.0.200.11).

Then, on another machine in the same VRack, we can launch a pgsql container:

	pgsql: # Hot standby
        image: docker.taktik.be/odoo/pgsql
        run:
            volume:
              - /media/SSD/odoo/containers/pgsql/postgres:/var/lib/postgresql/9.3/main
            env:
              - "PGSQL_HOT_STANDBY=on"
              - "SLAVEHOST=10.0.200.11"
              - "SLAVEPORT=5432"
              - "SLAVEPASSWORD=yourpassword"
              - "SLAVEUSER=replicator"
            detach: true
            restart: "always"
            
We only need to give some informations through the environment variables, such as the IP, port and password of the master.  
You can then check the logs in /var/log/supervisor/pgsql_slave.log to see if everything is running correctly.  
The first time it starts, it will **NOT** copy the databases automatically, to avoid erasing the PostgreSQL data directory.  
So you will need to access the container and run:

    supervisorctl restart pgsql_slave
    
This will **erase the PostgreSQL data directory** and initiate the copy from the master.  
Then, it will try to stay up to date by receiving the WAL from the master.

### Verifying replication status

In order to verify that the slave is running and up to date, you can check the logs at
/var/log/supervisor/pgsql_slave.log

You can also execute the script (on the slave)

	pgReplicationStatus.sh
	
This will show you: 

* last_replay_timestamp: the timestamp of the last replayed log (should be not far from the current date)
* replication_delay: difference between now and last_replay_timestamp
* pg_last_xlog_receive_location and pg_last_xlog_replay_location: the location of the last received log, and the location
of the last replayed log. It should be the same if the server is not under load.

You can also send /var/log/pg_replication.log to logstash.

You can also check the status of the replication clients on the master:

	pgClientReplicationStatus.sh
	
You will for instance have:

* backend_start: the date at which the slave started the replication
* state: state of the slave (should be streaming)
* byte_lag: the lag of the slave in bytes (should be low). You can compare that with the size of a wal segment:

	psql -U postgres -c "SHOW wal_segment_size";
	
If a wal segment is 16MB, you can divide the byte lag by 16777216 and see how many segments the slave is behind.

The pgReplicationStatus.sh