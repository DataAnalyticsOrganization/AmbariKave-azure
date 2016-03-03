#!/bin/bash 
###################################################
# Azure prepare machine script. 
#
# Currently the installation of the nodes in the 
# cluster is not automized. We need to run this 
# snippet on every node in the cluster.
# This script can be automatically distributed by 
# running the prepare_machines.sh script. 
###################################################

if [ -f id_rsa.pub ]; then 
  mkdir /root/.ssh
  chmod 700 /root/.ssh
  chown root:root /root/.ssh
  mv id_rsa.pub /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
  chown root:root /root/.ssh/authorized_keys
  
  restorecon -R -v /root/.ssh

  NODE=`hostname -s`
  DOMAIN=`hostname -d`
  echo "127.0.0.1   $NODE.$DOMAIN $NODE localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
  echo "::1   $NODE.$DOMAIN $NODE localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
  
  IPS=`ifconfig | grep "inet\saddr:[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | sed -r "s/.*inet addr:([0-9\.]+).*/\1/g"`
  for IP in $IPS; do
    if [ $IP != "127.0.0.1" ]; then
      echo "$IP   $NODE.$DOMAIN $NODE" >> /etc/hosts
    fi
  done
  
  # Needed for kavetoolbox
  yum -y install gcc gcc-c++
  nohup yum -y update &
  
else 
  echo "ERROR. no public key found."
fi
