#!/bin/bash

cp /tmp/* /host
cp /wait.sh /host
cp /init.sh /host

/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/install/wait.sh
/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/install/install.sh
/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/install/init.sh

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/wait.sh
/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/init.sh

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/wait.sh
/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/install.sh

# Sleep so that the Pod in the DaemonSet does not exit
sleep infinity