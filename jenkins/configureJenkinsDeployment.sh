#!/bin/bash
JENKINS_URL=$1

if [ -z $JENKINS_URL ]; then
        echo "ERROR: You must include the jenkins url such as http://jenkins:8080"
        exit 1
fi

curl -s -XPOST $JENKINS_URL/credentials/store/system/domain/_/createCredentials --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "dockerregcred",
    "username": "docker",
    "password": "7qehnRv37n",
    "description": "docker reg credentials for instance-1 nexus repudo ",
    "$class": "com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"
  }
}'
