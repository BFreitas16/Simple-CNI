#!/bin/bash

# Delete the CNI files
rm -rf /etc/cni/net.d/simple-cni.conf
rm -rf /opt/cni/bin/simple-cni
rm -rf /opt/cni/bin/simple-cni.log
rm -rf /opt/cni/bin/simple-cni-last_allocated_ip

echo ">>> Deleted CNI configuration files"

# Delete the bridge called cni0
ip link set cni0 down
brctl delbr cni0

echo ">>> Deleted cni0 bridge interface"

# Delete the IPTABLES rules created
iptables -D FORWARD -s 192.168.0.0/16 -j ACCEPT
iptables -D FORWARD -d 192.168.0.0/16 -j ACCEPT

echo ">>> Deleted Iptables rules"
