HELM chart for external loadbalancer



ssh -w 0:0 -f 91.149.218.39 -p 22 "ip addr add 10.10.11.1/24 dev tun1 && ip link set tun1 up && true && sleep 5"
ip addr add "10.10.11.157/24" dev tun0 && ip link set tun0 up