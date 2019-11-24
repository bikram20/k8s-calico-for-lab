#!/usr/bin/env bash

# Latest updates
apt-get update 
apt-get upgrade -y
apt-get install jq wget curl ipset ipvsadm  -y
apt-get install dialog apt-utils -y

# Docker

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update 
apt-get install docker-ce=5:18.09.9~3-0~ubuntu-bionic docker-ce-cli=5:18.09.9~3-0~ubuntu-bionic containerd.io -y


# Kubeadm
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet=1.15.5-00 kubeadm=1.15.5-00 kubectl=1.15.5-00
apt-mark hold kubelet kubeadm kubectl

# Pull Calico images and yaml's
docker pull calico/cni:v3.10.0
docker pull calico/pod2daemon-flexvol:v3.10.0
docker pull calico/node:v3.10.0
docker pull calico/kube-controllers:v3.10.0

# Download calicoctl and keep under /usr/local/bin
wget  https://github.com/projectcalico/calicoctl/releases/download/v3.10.0/calicoctl
chmod +x calicoctl
mv calicoctl /usr/local/bin

cat << EOF >> calicoctl.cfg
apiVersion: projectcalico.org/v3
kind: CalicoAPIConfig
metadata:
spec:
  datastoreType: "kubernetes"
  kubeconfig: "/home/ubuntu/.kube/config"
EOF

sudo mkdir -p /etc/calico
mv calicoctl.cfg /etc/calico

# Install Ansible-playbook
apt install software-properties-common -y
apt-add-repository ppa:ansible/ansible -y
apt update
apt install ansible -y

# Install ttyd for internet based terminal
wget https://github.com/tsl0922/ttyd/releases/download/1.5.2/ttyd_linux.x86_64
chmod +x ttyd_linux.x86_64
mv ttyd_linux.x86_64 /usr/local/bin/ttyd
