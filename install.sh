#!/bin/bash

# copy the CNI configuration file to its location
cp ./cni/simple-cni.conf /etc/cni/net.d/

# copy the CNI file to its location
cp ./cni/simple-cni /opt/cni/bin/
