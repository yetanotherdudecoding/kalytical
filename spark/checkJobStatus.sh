#!/bin/bash
#This script simply queries the kubernetes job api object to ascertain if the job has completed or not
res=""
while [ -z $res ]; do
        res=$(kubectl get job $1 -n bsavoy -o=json | jq '.status.conditions[] | .type')
        echo "Job state is not reported" 
        sleep 5
done

echo "Job state is: " $res
if [ "$res" = "\"Complete\"" ]; then
        exit 0
fi
exit 1
