#!/bin/bash

# @author: Bruno Freitas
# @version 1 (10/Feb/2023)
#
# This script must run on the master node when the K8s cluster
# is already deployed. 
#
# This script installs the necessary CNI files in each K8s node
# and run the necessary commands to make the CNI work:
# 1. copy the files to the correct folders on the K8s node
# 2. execute the init script to configure the CNI
#
# Requirements:
# a. Each K8s node has installed the 'rsync' tool
#    Do it by running: apt-get install -y rsync
# b. Each K8s node has installed the 'jq' tool
#    Do it by running: apt-get install -y jq
# c. Each K8s node has ssh keys
#    Do it by running: ssh-keygen -t rsa -b 4096
# d. Enable SSH access for the root user account
#    Do it by running: echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && systemctl restart sshd
# e. Enable passwordless SSH for each K8s note
#    Do it by running: ssh-copy-id -i /root/.ssh/id_rsa.pub <user>@<K8s-node>

# VARS

# User on each K8s node
user=root

# The template CNI Pod CIDR
podcidr_template='192.168.%s.0/24'
# Auxiliar variable to create the Pod CIDR
aux_podcidr=1 

# The template CNI configuration file
cni_config_file_template='
{
    "cniVersion" : "0.3.1",
    "name"       : "simple-cni",
    "type"       : "simple-cni",
    "podcidr"    : "%s"
}'

# MAIN

# Give running permition to CNI shell scripts
chmod +x install.sh
chmod +x uninstall.sh

# Create temporary file to get the information
kubectl get node -o json > nodes.info.json

# For each K8s node 
jq -r '.items[].status.addresses[0].address' nodes.info.json | while read -r ip; do 
    echo ">>> Node ${aux_podcidr} Information..."
    
    # Generate the Pod CIDR
    podcidr_node=$(printf "${podcidr_template}" $aux_podcidr)
    aux_podcidr=$(($aux_podcidr+1))

    echo ">>> Pod CIDR: ${podcidr_node}"

    # Generate the CNI configuration file
    cni_config_file_node=$(printf "${cni_config_file_template}" $podcidr_node)
    echo $cni_config_file_node > /tmp/simple-cni/cni/simple-cni.conf

    echo ">>> CNI configuration: ${cni_config_file_node}"

    # Create the CNI folder on node
    ssh -n $user@$ip 'mkdir -p /tmp/simple-cni'

    # Copy all the CNI necessary files to the node
    rsync -azr . $user@$ip:/tmp/simple-cni/

    echo ">>> Copied CNI files to the node"

    # SSH for the user home of the <IP> host and give permissions to execute the
    # the installation scrip and run it 
    ssh -n $user@$ip 'cd /tmp/simple-cni; ./install.sh'

    echo ">>> Executed the installation script on the node"
done
