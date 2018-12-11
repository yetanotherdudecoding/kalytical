rm -rf ./docker
git clone https://github.com/jenkinsci/docker.git
cp plugins.txt ./docker/plugins.txt

cat << EOF >> ./docker/Dockerfile
COPY plugins.txt /usr/local/bin/plugins.txt
RUN cat /usr/local/bin/plugins.txt | /usr/local/bin/install-plugins.sh
USER root
RUN curl -fsSl https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-get update && apt-get install -y apt-transport-https
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y maven docker kubectl && rm -rf /var/lib/apt/lists/*
USER \${user}
EOF