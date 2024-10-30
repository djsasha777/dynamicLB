#!/bin/bash

# Copy installation script to host
cp /tmp/* /host

# Copy wait script to the host 
cp /wait.sh /host

# Wait for updates to complete
/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/install/wait.sh
/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/install/install.sh

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/wait.sh
/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/install.sh

# Sleep so that the Pod in the DaemonSet does not exit
sleep infinity