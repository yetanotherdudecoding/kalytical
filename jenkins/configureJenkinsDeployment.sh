#!/bin/bash
JENKINS_URL=$1
echo "INFO: Configure jenkins deployment"
if [ -z $JENKINS_URL ]; then
        echo "ERROR: You must include the jenkins url such as http://jenkins:8080"
        exit 1
fi
ATTEMPTS=0
while [ "200" != "$(curl -sL -w %{http_code} $JENKINS_URL/ -o /dev/null)" -a "$ATTEMPTS" != "15" ]; do
        ((ATTEMPTS++))
        echo "WARN: Jenkins was not up, wait 10 seconds then try again. Attempt $ATTEMPTS/15"
        sleep 10
done

if [ "$ATTEMPTS" = "5" ]; then
        echo "ERROR: Jenkins did not come up after 5 attempts to reach it. 10 second timeout on each poll. Please check jenkins at $JENKINS_URL"
        exit 1
fi
echo "INFO: Configure kubernetes credential in Jenkins"
curl -s -XPOST $JENKINS_URL/credentials/store/system/domain/_/createCredentials --data-urlencode 'json={
  "": "0",
  "credentials": {
    "scope": "GLOBAL",
    "id": "k8s-kube-config-secret",
    "kubeconfigFile": "/home/.kube/config",
    "description": "this kubeconfig file was mounted as a k8s secret",
    "kubeconfigSource": {
	"stapler-class": "com.microsoft.jenkins.kubernetes.credentials.KubeconfigCredentials$FileOnMasterKubeconfigSource",
	"kubeconfigFile": "/home/.kube/config"
     },
    "$class": "com.microsoft.jenkins.kubernetes.credentials.KubeconfigCredentials"
  }
}'

RETCD=$?
if [ "$RETCD" != "0" ]; then
	echo "Problem creating kubeconfig credential in jenkins. Please check jenkins at $JENKINS_URL"
	exit 1
fi

jenkins/jobs/provisionJenkinsJobs.sh $JENKINS_URL
