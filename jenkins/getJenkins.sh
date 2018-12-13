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
RUN apt-get update && apt-get install -y docker
RUN mkdir -p /etc/sysconfig/
RUN apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y \
  && curl -fsSL https://download.docker.com/linux/debian/gpg |  apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian \$(lsb_release -cs) stable" \
  && apt-get update -y && apt-get install docker-ce -y 
USER \${user}
EOF
