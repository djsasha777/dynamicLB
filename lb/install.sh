#!/bin/bash
apt update
apt install shadowsocks-libev -y
apt-get install unzip -y
wget https://github.com/xjasonlyu/tun2socks/releases/download/v2.5.2/tun2socks-linux-amd64.zip
unzip tun2socks-linux-amd64.zip -d .
mv tun2socks-linux-amd64 /usr/bin/tun2socks
cp tun2socks.service /etc/systemd/system/tun2socks.service
mkdir /etc/tun2socks
cat  >> /etc/tun2socks/tun2socks.conf <<EOF
TUNNETWORK=10.10.0.0
TUNIP=10.10.0.1
TUNPREFIX=24
SSPROTOCOL=chacha20-ietf-poly1305
SSIP=195.0.0.1
SSPORT=8443
SSPASSWORD=YourPassword
EOF

systemctl enable --now tun2socks