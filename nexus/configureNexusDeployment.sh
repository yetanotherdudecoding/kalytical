#!/bin/bash
NEXUS_URL=$1
NEXUS_DOCKER_URL=$2
echo "INFO: Configure nexus deployment"
if [ -z $NEXUS_URL ]; then
        echo "ERROR: You must include the nexus url such as http://jenkins:8080"
        exit 1
fi
ATTEMPTS=0
while [ "true" != "$(curl --max-time 5 -u admin:admin123 $NEXUS_URL/service/metrics/healthcheck | jq '.deadlocks.healthy')" -a "$ATTEMPTS" != "15" ]; do
        ((ATTEMPTS++))
        echo "WARN: Nexus artifact repository was not up, wait 10 seconds then try again. Attempt $ATTEMPTS/15"
        sleep 10
done

if [ "$ATTEMPTS" = "5" ]; then
        echo "ERROR: Nexus did not come up after 15 attempts to reach it. 10 second timeout on each poll. Please check jenkins at $JENKINS_URL"
        exit 1
fi

echo "INFO: Run configure Nexus users and repository"
cd nexus
./provision.sh $NEXUS_URL
./preloadNexus.sh $NEXUS_DOCKER_URL $NEXUS_URL
echo "INFO: Finished setting up nexus"
