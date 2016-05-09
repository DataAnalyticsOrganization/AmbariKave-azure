#!/bin/bash

#This is to be executed on the cluster node designated for ambari
#Run this ONLY for a halfbaked installation - eg to clean if you killed the blueprint_deploy.py halfway. To remove Ambari altogether, use 'dev/clean.sh'.

BLUEPRINT=${1:-example}

curl -H "X-Requested-By: ambari" -X DELETE -u admin:admin "http://localhost:8080/api/v1/blueprints/$BLUEPRINT"

curl -H "X-Requested-By: ambari" -X DELETE -u admin:admin "http://localhost:8080/api/v1/clusters/$BLUEPRINT"
