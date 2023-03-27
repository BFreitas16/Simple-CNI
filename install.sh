#!/bin/bash

# Create (if not created) the CNI folders - just to make sure
mkdir -p /etc/cni/net.d/
mkdir -p /opt/cni/bin/

echo ">>> Created CNI folders"

# copy the CNI configuration file to its location
cp ./cni/simple-cni.conf /etc/cni/net.d/

# copy the CNI file to its location
cp ./cni/simple-cni /opt/cni/bin/

# Create the CNI log file (empty)
touch /opt/cni/bin/simple-cni.log

# Create the CNI IPAM cache file (starting at 2)
echo "2" > /opt/cni/bin/simple-cni-last_allocated_ip

echo ">>> Added CNI default files: Binary, Configuration, log file, and IPAM."

# Create the default CNI ENV variables
export CNI_PATH=/opt/cni/bin/
export NETCONFPATH=/etc/cni/net.d

echo ">>> Created CNI ENV variables."

# Creates the IPAM static file (this file contains the last
# IP address used in the host's subnet)
podcidr=$(cat /etc/cni/net.d/simple-cni.conf | jq -r ".podcidr")
podcidr_gw=$(echo $podcidr | sed "s:0/24:1:g") # returns gateway finishing in address .1

echo ">>> Pod CIDR: ${podcidr} ; Gateway: ${podcidr_gw}"

# Create a new bridge called cni0 and assign podcidr_gw/24 to it
brctl addbr cni0
ip link set cni0 up
ip addr add "${podcidr_gw}/24" dev cni0

# Configure IPTABLES to accept traffic from node-to-node
iptables -A FORWARD -s 192.168.0.0/16 -j ACCEPT
iptables -A FORWARD -d 192.168.0.0/16 -j ACCEPT

#cp simple-cni.conf /etc/cni/net.d/
#cp simple-cni /opt/cni/bin/
# ls -la /etc/cni/net.d/ | grep simple
# ls -la /opt/cni/bin/ | grep simple
#cat /opt/cni/bin/simple-cni.log
#cat /opt/cni/bin/simple-cni-last_allocated_ip