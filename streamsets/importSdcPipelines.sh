#!/bin/bash
#This script provisions sdc pipelines found in this folder
SDC_URL=$1
echo $SDC_URL
echo "INFO: Provision sdc pipelines in $(pwd)/pipelines"
if [ -z $SDC_URL ]; then
	echo "ERROR: You must specify a sdc url, such as http://sdc:8080"
	exit 10
fi
ATTEMPTS=0
while [ "200" != "$(curl -sL -w %{http_code} $SDC_URL/ -o /dev/null)" -a "$ATTEMPTS" != "5" ]; do
	((ATTEMPTS++))
	echo "WARN: SDC was not up, wait 10 seconds then try again. Attempt $ATTEMPTS/5"
	sleep 10
done

if [ "$ATTEMPTS" = "5" ]; then
	echo "ERROR: SDC did not come up after 5 attempts to reach it. 10 second timeout on each poll. Please check sdc at $SDC_URL"
	exit 1
fi

cd streamsets/pipelines
for JOB in $(ls *); do
	if [ -r $JOB ]; then
		echo $JOB
                pipeName=$(echo $JOB | awk 'BEGIN {FS="."}; {print $1}')
		SUBMIT_STR="curl -XPOST -u admin:admin -v -H 'Content-Type:application/json' -H 'X-Requested-By: Kalyticial Provisioning Script' -d "@$JOB" $SDC_URL/rest/v1/pipeline/$pipeName/import?overwrite=true"
		eval $SUBMIT_STR
		RETCD=$?
		echo "INFO: Created pipeline with return code " $RETCD
		if [ "$RETCD" != 0 ]; then
			echo "WARN: There was a problem creating one of the sdc jobs. Please check sdc is available at $SDC_URL"
			exit 1
		fi
	else
		echo "WARN: $JOB/config.xml was not readable. Please check folder. SDC job not creating for $JOB"
	fi
done

