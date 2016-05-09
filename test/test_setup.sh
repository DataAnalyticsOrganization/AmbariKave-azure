#!/bin/bash

#Check out:
#/var/log/azure/Microsoft.OSTCExtensions.CustomScriptForLinux/1.4.1.0
#for the logs.

#Test *without* redeploying, eg (as root):
#cd /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0
#/bin/bash ambarinode_setup.sh https://github.com/DataAnalyticsOrganization/AmbariKave-azure/archive/full_automatization.zip KaveAdmin KavePassword01 'localhost ambari gate ci nno-0 nno-1 data-0 data-1 data-2' 2.0-Beta https://raw.githubusercontent.com/DataAnalyticsOrganization/AmbariKave-azure/full_automatization/kave_blueprint/KAVEAzure.blueprint.json https://raw.githubusercontent.com/DataAnalyticsOrganization/AmbariKave-azure/full_automatization/kave_blueprint/KAVEAzure.cluster.json

#/var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0/contents/setup/bin/../../../AmbariKave-2.0-Beta/deployment/deploy_from_blueprint.py /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0/blueprint.json /var/lib/waagent/Microsoft.OSTCExtensions.CustomScriptForLinux-1.4.1.0/download/0/cluster.json.local --verbose --not-strict
