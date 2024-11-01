#!/bin/bash

cp /tmp/* /host
cp /wait.sh /host

/usr/bin/nsenter -m/proc/1/ns/mnt -- chmod u+x /tmp/install/*

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/softinstall.sh
/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/wait.sh

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/preinit.sh

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/init.sh

/usr/bin/nsenter -m/proc/1/ns/mnt /tmp/install/install.sh
