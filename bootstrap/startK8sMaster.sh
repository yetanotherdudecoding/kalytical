#!/bin/bash

if [ "root" != "$(whoami)" ]; then
        echo "This script is intended to be run as root"
        exit 0
fi

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y docker kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl disable firewalld && systemctl stop firewalld
cat << EOF | sudo /usr/bin/tee /etc/sysconfig/docker
INSECURE_REGISTRY="--insecure-registry=0.0.0.0/0"
EOF
systemctl enable docker && systemctl start docker

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system
systemctl enable kubelet && systemctl start kubelet
kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
sleep 30
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
kubectl apply -f spark/spark-rbac.yaml
echo "##########################################"
echo "Remember to add --insecure-registry=0.0.0.0/0 parameter for testing/dev"

echo "quick fix to enable docker builds in jenkins"
chmod 777 /var/run/docker.sock
