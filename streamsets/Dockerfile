#Copyright 2017 StreamSets Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
ARG DOCKER_REGISTRY=instance-1.us-east1-b.c.sandbox-224519.internal:8080
FROM ${DOCKER_REGISTRY}/openjdk:8-jre-alpine
LABEL maintainer="Adam Kunicki <adam@streamsets.com>"

# glibc installation courtesy https://github.com/jeanblanchard/docker-alpine-glibc
ENV GLIBC_VERSION 2.25-r0

# Download and install glibc
# Note: libidn is required as a workaround for addressing AWS Kinesis Producer issue (https://github.com/awslabs/amazon-kinesis-producer/issues/86)
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  apk add libidn && \
  apk del curl && \
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*

# We set a UID/GID for the SDC user because certain test environments require these to be consistent throughout
# the cluster. We use 20159 because it's above the default value of YARN's min.user.id property.
ARG SDC_UID=20159

RUN apk --no-cache add bash \
    curl \
    krb5-libs \
    krb5 \
    libstdc++ \
    libuuid \
    sed

# Begin Data Collector installation
ARG SDC_VERSION=3.7.1
ARG SDC_URL=http://instance-1.us-east1-b.c.sandbox-224519.internal:8081/repository/raw-artifacts/oss/streamsets-datacollector-all-3.7.1.tgz
ARG SDC_USER=sdc
# SDC_HOME is where executables and related files are installed. Used in setup_mapr script.
ARG SDC_HOME="/opt/streamsets-datacollector-${SDC_VERSION}"

# The paths below should generally be attached to a VOLUME for persistence.
# SDC_CONF is where configuration files are stored. This can be shared.
# SDC_DATA is a volume for storing collector state. Do not share this between containers.
# SDC_LOG is an optional volume for file based logs.
# SDC_RESOURCES is where resource files such as runtime:conf resources and Hadoop configuration can be placed.
# STREAMSETS_LIBRARIES_EXTRA_DIR is where extra libraries such as JDBC drivers should go.
# USER_LIBRARIES_DIR is where custom stage libraries are installed.
ENV SDC_CONF=/etc/sdc \
    SDC_DATA=/data \
    SDC_DIST=${SDC_HOME} \
    SDC_HOME=${SDC_HOME} \
    SDC_LOG=/logs \
    SDC_RESOURCES=/resources \
    USER_LIBRARIES_DIR=/opt/streamsets-datacollector-user-libs
ENV STREAMSETS_LIBRARIES_EXTRA_DIR="${SDC_DIST}/streamsets-libs-extras"

# Run the SDC configuration script.
COPY sdc-configure.sh *.tgz /tmp/
RUN /tmp/sdc-configure.sh

# Install any additional stage libraries if requested
ARG SDC_LIBS
RUN if [ -n "${SDC_LIBS}" ]; then "${SDC_DIST}/bin/streamsets" stagelibs -install="${SDC_LIBS}"; fi

# Copy files in $PROJECT_ROOT/resources dir to the SDC_RESOURCES dir.
COPY resources/ ${SDC_RESOURCES}/
RUN chown -R sdc ${SDC_RESOURCES}/

# Copy local "sdc-extras" libs to STREAMSETS_LIBRARIES_EXTRA_DIR.
# Local files should be placed in appropriate stage lib subdirectories.  For example
# to add a JDBC driver like my-jdbc.jar to the JDBC stage lib, the local file my-jdbc.jar
# should be at the location $PROJECT_ROOT/sdc-extras/streamsets-datacollector-jdbc-lib/lib/my-jdbc.jar
COPY sdc-extras/ ${STREAMSETS_LIBRARIES_EXTRA_DIR}/
RUN chown -R sdc ${STREAMSETS_LIBRARIES_EXTRA_DIR}/

USER ${SDC_USER}
EXPOSE 18630
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dc", "-exec"]
