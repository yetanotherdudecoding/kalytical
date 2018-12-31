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


yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 -y
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo -y
yum install docker-ce -y
cat << EOF | /usr/bin/tee /etc/docker/daemon.json
{
        "insecure-registries" : [ "0.0.0.0/0" ]
}
EOF

yum install -y docker kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl disable firewalld && systemctl stop firewalld
cat << EOF | /usr/bin/tee /etc/sysconfig/docker
INSECURE_REGISTRY="--insecure-registry=0.0.0.0/0"
EOF
systemctl enable docker && systemctl start docker
chmod 777 /var/run/docker.sock #Ugly but effective fix so jenkins can build docker images

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system
systemctl enable kubelet && systemctl start kubelet
kubeadm init --pod-network-cidr=10.244.0.0/16
echo "Setup kubernetes credentials"
mkdir -p $HOME/.kube
cp -if /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "Applying minimum necessary setup for bootstrapping the rest of the cluster from jenkins"
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
kubectl create namespace bsavoy
mkdir -p /k8s-pvs/{jenkins_home,sdc_data}
chmod 777 -R /k8s-pvs
kubectl create secret generic jenkins-k8s-kube-config --from-file=/root/.kube/config -n bsavoy
kubectl create secret generic jenkins-docker-config --from-file=jenkins/config.json -n bsavoy
kubectl apply -f jenkins/jenkins-deploy.yaml
#Give jenkins a chance to pull and start initializing
jenkins/configureJenkinsDeployment.sh http://$(hostname):30080
echo "At this point, you should navigate to http://$(hostname):30080 and use jenkins to bootstrap the rest of the resources"
echo "I would not reccomend bringing additional nodes into the cluster at this time since hostpath is used for persistence"
#kubeadm token create --print-join-command
