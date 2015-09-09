# Rsync Host Docker image

This image allows to share a directory of the host in order to sync it with the [rsync image](../rsync/readme.md).  
The rsync image will connect through SSH (for now its key is declared in the authorized_keys file),
and will sync everything in the /sync directory.

So, for instance, if you want to sync the /tmp directory of your host, simply declare a volume when running
the container:

    -v "/tmp:/sync:ro"
    
We mount the /tmp directory inside the container as /sync, readonly.  
Then, you simply have to configure the tk_rsync container.

## RSA Keys

In order for the rsync container to be able to connect, you can mount an authorized_keys file in /root/.ssh/authorized_keys as a volume.
