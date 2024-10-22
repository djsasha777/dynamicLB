#!/bin/sh
HOST=91.149.218.39
HOST_PORT=22
TUN_LOCAL=0
TUN_REMOTE=0
IP_LOCAL=10.10.10.2
IP_REMOTE=10.10.10.1
IP_MASK=30
echo "Starting VPN tunnel ..." 
modprobe tun
ssh -w ${TUN_LOCAL}:${TUN_REMOTE} -f ${HOST} -p ${HOST_PORT} "\
ip addr add ${IP_REMOTE}/${IP_MASK} dev tun${TUN_REMOTE} \
&& ip link set tun${TUN_REMOTE} up \
&& true"
sleep 3
ip addr add ${IP_LOCAL}/${IP_MASK} dev tun${TUN_LOCAL}
ip link set tun${TUN_LOCAL} up
echo "... done."

#Add “PermitTunnel yes” to /etc/ssh/sshd_config
#sysctl -w net.ipv4.ip_forward=1