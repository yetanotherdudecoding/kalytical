#!/bin/bash
#This script provisions jenkins pipelines found in this folder
JENKINS_URL=$1
echo $JENKINS_URL
echo "INFO: Provision jenkins pipelines in $(pwd)/jobs"
if [ -z $JENKINS_URL ]; then
	echo "ERROR: You must specify a jenkins url, such as http://jenkins:8080"
	exit 10
fi
ATTEMPTS=0
while [ "200" != "$(curl --connect-timeout 5 -sL -w %{http_code} $JENKINS_URL/ -o /dev/null)" -a "$ATTEMPTS" != "5" ]; do
	((ATTEMPTS++))
	echo "WARN: Jenkins was not up, wait 10 seconds then try again. Attempt $ATTEMPTS/5"
	sleep 10
done

if [ "$ATTEMPTS" = "5" ]; then
	echo "ERROR: Jenkins did not come up after 5 attempts to reach it. 10 second timeout on each poll. Please check jenkins at $JENKINS_URL"
	exit 1
fi

cd jenkins/jobs
for JOB in $(ls -d */ | cut -f1 -d'/'); do
	if [ -r $JOB/config.xml ]; then
		SUBMIT_STR="curl -s -XPOST '$JENKINS_URL/createItem?name=$JOB' --data-binary @$JOB/config.xml -H 'Content-Type:text/xml' > /dev/null"
		eval $SUBMIT_STR
		RETCD=$?
		echo "INFO: Created pipeline with return code " $RETCD
		if [ "$RETCD" != 0 ]; then
			echo "WARN: There was a problem creating one of the jenkins jobs. Please check jenkins is available at $JENKINS_URL"
			exit 1
		fi
	else
		echo "WARN: $JOB/config.xml was not readable. Please check folder. Jenkins job not creating for $JOB"
	fi
done

