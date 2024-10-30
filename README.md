HELM chart for external loadbalancer



ssh -w 0:0 -t root@91.149.218.39 "ip addr add 10.10.11.1/24 dev tun1 && ip link set tun1 up && true && sleep 5"
ip addr add "10.10.11.157/24" dev tun0 && ip link set tun0 up

ssh -w 0:0 -t root@91.149.218.39 -o Tunnel=ethernet "ls"

ssh -o "PermitLocalCommand=yes" \
-o "LocalCommand=ifconfig tap5 up && ifconfig tap5 10.0.25.2 netmask 255.255.255.0" \
-o Tunnel=ethernet \
-w 5:5 \
-t root@91.149.218.39 \
-o ConnectTimeout=10 "ifconfig tap5 up && ifconfig tap5 10.0.25.1 netmask 255.255.255.0"


ssh -o "PermitLocalCommand=yes" \
-o "LocalCommand=ifconfig tap7 up && ifconfig tap7 10.0.25.8 netmask 255.255.255.0" \
-o Tunnel=ethernet \
-w 7:7 \
-t root@91.149.218.39 \ 
-o ConnectTimeout=10 "ifconfig tap7 up && ifconfig tap7 10.0.25.9 netmask 255.255.255.0"

ssh -o "PermitLocalCommand=yes" \
-o "LocalCommand=ifconfig tap2 up && ifconfig tap2 10.0.25.34 netmask 255.255.255.0" \
-o Tunnel=ethernet \
-w 2:2 \
-t root@91.149.218.39 \
-o ConnectTimeout=10 "ifconfig tap2 up && ifconfig tap2 10.0.25.39 netmask 255.255.255.0"


LOCIP=$(ifconfig {{ .Values.connect.localDev }} | grep 'inet' | awk '{print $2}' | cut -d '.' -f 4 | sed '1q')









    #!/usr/bin/env bash
    if [ ! -f "LOCALINIT" ]; then
    echo "LOCAL initialisation..."
    sysctl -w net.ipv4.ip_forward=1
    if ! grep -q '^PermitTunnel yes$' /etc/ssh/sshd_config; then
    echo 'PermitTunnel yes' | sudo tee -a /etc/ssh/sshd_config > /dev/null
    service ssh restart
    sleep 5
    apt update && apt install -y --fix-missing expect bird net-tools && touch LOCALINIT
    fi
    else
    echo "LOCAL is already initialized"
    fi
  reminstall.sh: |
    #!/usr/bin/env bash   
    if [ ! -f "REMOTEINIT" ]; then
    echo "REMOTE INIT START"
    if [ ! -f ~/.ssh/id_rsa ]; then
    echo "SSH key generation..."
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
    fi
    expect -c "spawn ssh-copy-id root@{{ .Values.connect.remoteHost }}
    expect \"password:\"
    send \"{{ .Values.connect.remoteSshPass }}\r\"
    interact"
    ssh root@{{ .Values.connect.remoteHost }} "apt update
    apt install -y --fix-missing haproxy bird 
    sysctl -w net.ipv4.ip_forward=1
    if ! grep -q '^PermitTunnel yes$' /etc/ssh/sshd_config; then
    echo 'PermitTunnel yes' | sudo tee -a /etc/ssh/sshd_config > /dev/null
    systemctl restart sshd
    sleep 5
    fi"
    touch REMOTEINIT    
    else
    echo "REMOTE is already initialized"
    fi
  tuninstall.sh: |
