# Simple-CNI
The simplest CNI made in Shell Scripting

### Author

| Number  | Name              | Email                               |
|---------|-------------------|------------------------------------|
| 98678   | Bruno Freitas     | <mailto:bruno.freitas@tecnico.ulisboa.pt>   |

------------------------------
# Table of Contents
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Installation](#installation)

------------------------------
# Project Structure
The folder structure of this project is as follows:
```
|- install-cni.sh
|- install.sh
|- uninstall.sh
\- cni
    |- simple-cni
    \- simple-cni.conf
```

- At the root there is the `install-cni.sh` script to install the CNI in each node. Basically, it copies the necessary files to each machine and execute the install.sh script.
- The `install.sh` script is the local installation on the node. It is responsible to do the basic configuration of the CNI.
- The `uninstall.sh` script is to uninstall the CNI. By executing this script on each file, all the CNI resources are deleted.
- The `cni` folder contains the CNI binary and a CNI configuration file example. Inside of this folder there is:
  - The `simple-cni` CNI binary (in thi case, a shell script).
  - The `simple-cni.conf` CNI configuration file.

------------------------------
# Requirements
a. Each K8s node has installed the 'rsync' tool. Do it by running:
```
apt-get install -y rsync
```

b. Each K8s node has installed the 'jq' tool. Do it by running:
```
apt-get install -y jq
```

c. Each K8s node has ssh keys. Do it by running:
```
ssh-keygen -t rsa -b 4096
```

d. Enable SSH access for the root user account. Do it by running:
```
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && systemctl restart sshd
```

e. Enable passwordless SSH for each K8s note. Do it by running:
```
ssh-copy-id -i /root/.ssh/id_rsa.pub <user>@<K8s-node>
```

------------------------------
# Installation
To install this CNI run the following commands on root:
1. Give previledges to run the installation script
```
chmod +x install-cni.sh
```

2. Run the installation scrip
```
./install-cni.sh
```
