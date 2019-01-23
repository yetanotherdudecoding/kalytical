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

yum update -y
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

yum install -y kubelet kubeadm kubectl jq groovy --disableexcludes=kubernetes
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

HOST=$(hostname -f)
DOCKER_REGISTRY="$HOST:30880"
NEXUS_SED_URL="http:\/\/$HOST:30881"
NEXUS_ARTIFACT_URL="http://$HOST:30881"
JENKINS_URL="$HOST:30080"
SDC_URL="$HOST:30530"
GIT_BRANCH=$(git branch | grep \* | awk '{print $2}' | sed 's/\//\\\//')

sed -i "s/DOCKER_REG_URL/$DOCKER_REGISTRY/g" jenkins/jenkins-deploy.yaml bootstrap/config.json jenkins/jobs/*/config.xml
sed -i "s/NEXUS_URL/$NEXUS_SED_URL/g" jenkins/jobs/*/config.xml
sed -i "s/STREAMSETS_URL/$SDC_URL/g" jenkins/jobs/*/config.xml
sed -i "s/DEFAULT_JENKINS_BUILD_BRANCH/$GIT_BRANCH/g" jenkins/jobs/*/config.xml

cp bootstrap/config.json /var/lib/kubelet/
cp bootstrap/config.json jenkins/
mkdir ~/.docker
cp bootstrap/config.json ~/.docker/
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
kubectl create namespace bsavoy
kubectl create secret docker-registry regcred --docker-server=$DOCKER_REGISTRY --docker-username=docker --docker-password=dockerpass
kubectl -n bsavoy create secret docker-registry regcred --docker-server=$DOCKER_REGISTRY --docker-username=docker --docker-password=dockerpass

#TODO - Do we need this if we're using config.json for docker credentials in kubelet configuration? 
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "regcred"}]}'
kubectl patch serviceaccount default -n bsavoy -p '{"imagePullSecrets": [{"name": "regcred"}]}'

mkdir -p /k8s-pvs/{jenkins_home,sdc_data,nexus-data}
chmod 777 -R /k8s-pvs
chown -R 200 /k8s-pvs/nexus-data

kubectl apply -f nexus/nexus-deploy.yaml
nexus/configureNexusDeployment.sh $NEXUS_ARTIFACT_URL $DOCKER_REGISTRY

kubectl create secret generic jenkins-k8s-kube-config --from-file=/root/.kube/config -n bsavoy
kubectl create secret generic jenkins-docker-config --from-file=jenkins/config.json -n bsavoy
jenkins/build.sh $DOCKER_REGISTRY
kubectl apply -f jenkins/jenkins-deploy.yaml
jenkins/configureJenkinsDeployment.sh $JENKINS_URL
rm jenkins/config.json

sed -i "s/$DOCKER_REGISTRY/DOCKER_REG_URL/g" jenkins/jobs/*/config.xml jenkins/jenkins-deploy.yaml bootstrap/config.json
sed -i "s/$NEXUS_SED_URL/NEXUS_URL/g" jenkins/jobs/*/config.xml
sed -i "s/$SDC_URL/STREAMSETS_URL/g" jenkins/jobs/*/config.xml
sed -i "s/$GIT_BRANCH/DEFAULT_JENKINS_BUILD_BRANCH/g" jenkins/jobs/*/config.xml

echo "At this point, you should navigate to $JENKINS_URL and use jenkins to bootstrap the rest of the resources"
echo "I would not reccomend bringing additional nodes into the cluster at this time since hostpath is used for persistence"
#kubeadm token create --print-join-command
